import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart' hide ActivityType;
import 'package:geocoding/geocoding.dart';
import 'package:vector/models/user_model.dart';
import 'package:vector/models/session_tracking_model.dart';
import 'package:vector/core/services/session_service.dart';
import 'package:vector/core/services/firebase_service.dart';
import 'package:vector/core/constants.dart';

enum HistoryFilter { week, month, year }

class ProfileViewModel extends ChangeNotifier {
  final SessionService _sessionService = SessionService();
  final FirebaseDatabase _database = FirebaseService.instance.database;

  UserProfile? _profile;
  List<SessionModel> _sessionHistory = [];
  HistoryFilter _currentFilter = HistoryFilter.week;
  bool _isLoading = false;
  String? _error;

  // Getters
  UserProfile? get profile => _profile;
  List<SessionModel> get sessionHistory => _sessionHistory;
  HistoryFilter get currentFilter => _currentFilter;
  bool get isLoading => _isLoading;
  String? get error => _error;

  String? get userId => FirebaseService.instance.userId;
  User? get currentUser => FirebaseService.instance.currentUser;

  /// Get user display name
  String get displayName {
    if (_profile?.name != null && _profile!.name!.isNotEmpty) {
      return _profile!.name!;
    }
    if (currentUser?.displayName != null &&
        currentUser!.displayName!.isNotEmpty) {
      return currentUser!.displayName!;
    }
    if (currentUser?.email != null) {
      return currentUser!.email!.split('@').first;
    }
    return 'User';
  }

  /// Get user location
  String get location => _profile?.location ?? 'Location not set';

  /// Get user email
  String get email => currentUser?.email ?? '';

  /// Get user photo URL
  String? get photoUrl => currentUser?.photoURL ?? _profile?.photoUrl;

  /// Load user profile from Firebase
  Future<void> loadProfile() async {
    if (userId == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final snapshot = await _database.ref('$usersPath/$userId/profile').get();

      if (snapshot.exists && snapshot.value != null) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        _profile = UserProfile.fromJson(data);
      } else {
        // Create default profile from auth data
        _profile = UserProfile(
          userId: userId,
          name: currentUser?.displayName,
          email: currentUser?.email,
          photoUrl: currentUser?.photoURL,
        );
      }
    } catch (e) {
      _error = 'Failed to load profile';
      debugPrint('Error loading profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Save/update user profile
  Future<bool> updateProfile({
    String? name,
    String? location,
    String? photoUrl,
  }) async {
    if (userId == null) return false;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedProfile = (_profile ?? UserProfile()).copyWith(
        userId: userId,
        name: name ?? _profile?.name,
        email: currentUser?.email,
        location: location ?? _profile?.location,
        photoUrl: photoUrl ?? _profile?.photoUrl,
        updatedAt: DateTime.now(),
        createdAt: _profile?.createdAt ?? DateTime.now(),
      );

      await _database
          .ref('$usersPath/$userId/profile')
          .set(updatedProfile.toJson());
      _profile = updatedProfile;

      // Also update Firebase Auth display name if name changed
      if (name != null && name.isNotEmpty) {
        await currentUser?.updateDisplayName(name);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to update profile';
      debugPrint('Error updating profile: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Fetch current location and update profile
  Future<bool> updateLocationFromGPS() async {
    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _error = 'Location permission denied';
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _error = 'Location permission permanently denied';
        return false;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      // Reverse geocode to get city/country
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final city =
            placemark.locality ?? placemark.subAdministrativeArea ?? '';
        final country = placemark.country ?? '';
        final locationString = city.isNotEmpty && country.isNotEmpty
            ? '$city, $country'
            : city.isNotEmpty
            ? city
            : country;

        if (locationString.isNotEmpty) {
          return await updateProfile(location: locationString);
        }
      }

      return false;
    } catch (e) {
      _error = 'Failed to get location';
      debugPrint('Error getting location: $e');
      return false;
    }
  }

  /// Set history filter and reload sessions
  Future<void> setFilter(HistoryFilter filter) async {
    _currentFilter = filter;
    notifyListeners();
    await loadSessionHistory();
  }

  /// Load session history based on current filter
  Future<void> loadSessionHistory() async {
    if (userId == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      switch (_currentFilter) {
        case HistoryFilter.week:
          _sessionHistory = await _sessionService.getWeekSessions(userId!);
          break;
        case HistoryFilter.month:
          _sessionHistory = await _sessionService.getMonthSessions(userId!);
          break;
        case HistoryFilter.year:
          _sessionHistory = await _sessionService.getYearSessions(userId!);
          break;
      }
    } catch (e) {
      _error = 'Failed to load session history';
      debugPrint('Error loading session history: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Group sessions by date for display
  Map<String, List<SessionModel>> get groupedSessions {
    final Map<String, List<SessionModel>> grouped = {};

    for (final session in _sessionHistory) {
      final dateKey = _formatDateKey(session.startTime);
      grouped.putIfAbsent(dateKey, () => []);
      grouped[dateKey]!.add(session);
    }

    return grouped;
  }

  String _formatDateKey(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]},${date.year}';
  }

  /// Initialize profile and load session history
  Future<void> initialize() async {
    await loadProfile();
    await loadSessionHistory();
  }

  /// Clear all data (for logout)
  void clear() {
    _profile = null;
    _sessionHistory = [];
    _currentFilter = HistoryFilter.week;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}
