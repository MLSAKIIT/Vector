import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart' hide ActivityType;
import 'package:vector/models/session_tracking_model.dart';
import 'package:vector/core/services/session_service.dart';
import 'package:vector/core/services/firebase_service.dart';

/// ViewModel for managing session tracking state
class SessionViewModel extends ChangeNotifier {
  final SessionService _sessionService = SessionService();

  // State
  SessionModel? _activeSession;
  String? _activeSessionId;
  List<SessionModel> _todaySessions = [];
  TodaySummary _todaySummary = TodaySummary();
  bool _isLoading = false;
  String? _error;
  Position? _currentPosition;
  double _currentSpeed = 0.0;
  StreamSubscription<Position>? _positionSubscription;
  Timer? _durationTimer;

  // Getters
  SessionModel? get activeSession => _activeSession;
  String? get activeSessionId => _activeSessionId;
  List<SessionModel> get todaySessions => _todaySessions;
  TodaySummary get todaySummary => _todaySummary;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasActiveSession => _activeSession != null;
  Position? get currentPosition => _currentPosition;
  double get currentSpeed => _currentSpeed;
  double get currentSpeedKmh => _currentSpeed * 3.6;

  String? get _userId => FirebaseService.instance.userId;

  /// Load today's sessions and summary
  Future<void> loadTodaySessions() async {
    if (_userId == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _todaySessions = await _sessionService.getTodaySessions(_userId!);
      _todaySummary = TodaySummary.fromSessions(_todaySessions);

      // Check for active session
      final active = await _sessionService.getActiveSession(_userId!);
      if (active != null) {
        _activeSession = active;
        _activeSessionId = active.id;
      }
    } catch (e) {
      _error = 'Failed to load sessions: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Check and request location permissions
  Future<bool> checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _error = 'Location services are disabled.';
      notifyListeners();
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _error = 'Location permissions are denied.';
        notifyListeners();
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _error = 'Location permissions are permanently denied.';
      notifyListeners();
      return false;
    }

    return true;
  }

  /// Start a new tracking session
  Future<bool> startSession(ActivityType activityType) async {
    if (_userId == null) {
      _error = 'User not authenticated';
      notifyListeners();
      return false;
    }

    // Check permissions
    final hasPermission = await checkLocationPermission();
    if (!hasPermission) return false;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Get initial position
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      _currentPosition = position;

      // Create session in Firebase
      _activeSessionId = await _sessionService.startSession(
        userId: _userId!,
        activityType: activityType,
      );

      // Initialize active session
      _activeSession = SessionModel(
        id: _activeSessionId,
        userId: _userId!,
        activityType: activityType,
        startTime: DateTime.now(),
        route: [
          LocationPoint(
            latitude: position.latitude,
            longitude: position.longitude,
            altitude: position.altitude,
            speed: position.speed,
            timestamp: DateTime.now(),
          ),
        ],
        isActive: true,
      );

      // Start location tracking
      _startLocationTracking();

      // Start duration timer
      _startDurationTimer();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to start session: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Start listening to location updates
  void _startLocationTracking() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5, // Update every 5 meters
    );

    _positionSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position position) {
            _onLocationUpdate(position);
          },
        );
  }

  /// Handle location update
  void _onLocationUpdate(Position position) {
    if (_activeSession == null) return;

    _currentPosition = position;
    _currentSpeed = position.speed.clamp(0, double.infinity);

    // Create new location point
    final newPoint = LocationPoint(
      latitude: position.latitude,
      longitude: position.longitude,
      altitude: position.altitude,
      speed: position.speed,
      timestamp: DateTime.now(),
    );

    // Calculate distance from last point
    double addedDistance = 0;
    if (_activeSession!.route.isNotEmpty) {
      final lastPoint = _activeSession!.route.last;
      addedDistance = _calculateDistance(
        lastPoint.latitude,
        lastPoint.longitude,
        newPoint.latitude,
        newPoint.longitude,
      );
    }

    // Update session
    final newRoute = [..._activeSession!.route, newPoint];
    final newTotalDistance = _activeSession!.totalDistance + addedDistance;
    final newMaxSpeed = max(_activeSession!.maxSpeed, position.speed);

    // Calculate average speed
    final duration = DateTime.now().difference(_activeSession!.startTime);
    final avgSpeed = duration.inSeconds > 0
        ? newTotalDistance / duration.inSeconds
        : 0.0;

    _activeSession = _activeSession!.copyWith(
      route: newRoute,
      totalDistance: newTotalDistance,
      maxSpeed: newMaxSpeed,
      averageSpeed: avgSpeed,
      duration: duration,
    );

    notifyListeners();
  }

  /// Start timer to update duration
  void _startDurationTimer() {
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_activeSession == null) return;

      final duration = DateTime.now().difference(_activeSession!.startTime);
      _activeSession = _activeSession!.copyWith(duration: duration);
      notifyListeners();
    });
  }

  /// Stop the current session
  Future<void> stopSession({double userWeightKg = 70}) async {
    if (_activeSession == null || _activeSessionId == null || _userId == null) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Stop tracking
      await _positionSubscription?.cancel();
      _positionSubscription = null;
      _durationTimer?.cancel();
      _durationTimer = null;

      // Calculate calories
      final calories = SessionService.calculateCalories(
        activityType: _activeSession!.activityType,
        distanceMeters: _activeSession!.totalDistance,
        weightKg: userWeightKg,
      );

      // Update session with final data
      final finalSession = _activeSession!.copyWith(
        caloriesBurned: calories,
        isActive: false,
        endTime: DateTime.now(),
      );

      // Save to Firebase
      await _sessionService.endSession(
        userId: _userId!,
        sessionId: _activeSessionId!,
        session: finalSession,
      );

      // Add to today's sessions
      _todaySessions.add(finalSession);
      _todaySummary = TodaySummary.fromSessions(_todaySessions);

      // Clear active session
      _activeSession = null;
      _activeSessionId = null;
      _currentSpeed = 0;
    } catch (e) {
      _error = 'Failed to save session: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Calculate distance between two points using Haversine formula
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371000; // meters
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) => degrees * pi / 180;

  /// Clean up resources
  @override
  void dispose() {
    _positionSubscription?.cancel();
    _durationTimer?.cancel();
    super.dispose();
  }
}
