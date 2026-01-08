import 'package:latlong2/latlong.dart';

/// Activity types supported in the app
enum ActivityType { walking, running, cycling }

/// Extension to get display properties for activity types
extension ActivityTypeExtension on ActivityType {
  String get displayName {
    switch (this) {
      case ActivityType.walking:
        return 'Walking';
      case ActivityType.running:
        return 'Running';
      case ActivityType.cycling:
        return 'Cycling';
    }
  }

  String get icon {
    switch (this) {
      case ActivityType.walking:
        return '🚶';
      case ActivityType.running:
        return '🏃';
      case ActivityType.cycling:
        return '🚴';
    }
  }
}

/// Represents a single location point in a session
class LocationPoint {
  final double latitude;
  final double longitude;
  final double altitude;
  final double speed; // in m/s
  final DateTime timestamp;

  LocationPoint({
    required this.latitude,
    required this.longitude,
    this.altitude = 0.0,
    this.speed = 0.0,
    required this.timestamp,
  });

  LatLng get latLng => LatLng(latitude, longitude);

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'altitude': altitude,
    'speed': speed,
    'timestamp': timestamp.toIso8601String(),
  };

  factory LocationPoint.fromJson(Map<String, dynamic> json) => LocationPoint(
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
    altitude: (json['altitude'] as num?)?.toDouble() ?? 0.0,
    speed: (json['speed'] as num?)?.toDouble() ?? 0.0,
    timestamp: DateTime.parse(json['timestamp'] as String),
  );
}

/// Represents a fitness tracking session
class SessionModel {
  final String? id;
  final String userId;
  final ActivityType activityType;
  final DateTime startTime;
  final DateTime? endTime;
  final List<LocationPoint> route;
  final double totalDistance; // in meters
  final Duration duration;
  final double averageSpeed; // in m/s
  final double maxSpeed; // in m/s
  final double caloriesBurned;
  final bool isActive;

  SessionModel({
    this.id,
    required this.userId,
    required this.activityType,
    required this.startTime,
    this.endTime,
    this.route = const [],
    this.totalDistance = 0.0,
    this.duration = Duration.zero,
    this.averageSpeed = 0.0,
    this.maxSpeed = 0.0,
    this.caloriesBurned = 0.0,
    this.isActive = true,
  });

  /// Create a copy with updated fields
  SessionModel copyWith({
    String? id,
    String? userId,
    ActivityType? activityType,
    DateTime? startTime,
    DateTime? endTime,
    List<LocationPoint>? route,
    double? totalDistance,
    Duration? duration,
    double? averageSpeed,
    double? maxSpeed,
    double? caloriesBurned,
    bool? isActive,
  }) {
    return SessionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      activityType: activityType ?? this.activityType,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      route: route ?? this.route,
      totalDistance: totalDistance ?? this.totalDistance,
      duration: duration ?? this.duration,
      averageSpeed: averageSpeed ?? this.averageSpeed,
      maxSpeed: maxSpeed ?? this.maxSpeed,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Convert distance to km
  double get distanceInKm => totalDistance / 1000;

  /// Convert speed to km/h
  double get averageSpeedKmh => averageSpeed * 3.6;
  double get maxSpeedKmh => maxSpeed * 3.6;

  /// Format duration as HH:MM:SS
  String get formattedDuration {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  /// Convert to JSON for Firebase
  Map<String, dynamic> toJson() => {
    'userId': userId,
    'activityType': activityType.name,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime?.toIso8601String(),
    'route': route.map((p) => p.toJson()).toList(),
    'totalDistance': totalDistance,
    'durationSeconds': duration.inSeconds,
    'averageSpeed': averageSpeed,
    'maxSpeed': maxSpeed,
    'caloriesBurned': caloriesBurned,
    'isActive': isActive,
  };

  /// Create from Firebase JSON
  factory SessionModel.fromJson(Map<String, dynamic> json, {String? id}) {
    final routeList =
        (json['route'] as List<dynamic>?)
            ?.map((e) => LocationPoint.fromJson(Map<String, dynamic>.from(e)))
            .toList() ??
        [];

    return SessionModel(
      id: id,
      userId: json['userId'] as String,
      activityType: ActivityType.values.firstWhere(
        (e) => e.name == json['activityType'],
        orElse: () => ActivityType.walking,
      ),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
      route: routeList,
      totalDistance: (json['totalDistance'] as num?)?.toDouble() ?? 0.0,
      duration: Duration(
        seconds: (json['durationSeconds'] as num?)?.toInt() ?? 0,
      ),
      averageSpeed: (json['averageSpeed'] as num?)?.toDouble() ?? 0.0,
      maxSpeed: (json['maxSpeed'] as num?)?.toDouble() ?? 0.0,
      caloriesBurned: (json['caloriesBurned'] as num?)?.toDouble() ?? 0.0,
      isActive: json['isActive'] as bool? ?? false,
    );
  }
}

/// Summary of today's activities
class TodaySummary {
  final double walkingDistance;
  final Duration walkingDuration;
  final double cyclingDistance;
  final Duration cyclingDuration;
  final double runningDistance;
  final Duration runningDuration;
  final double totalCalories;

  TodaySummary({
    this.walkingDistance = 0.0,
    this.walkingDuration = Duration.zero,
    this.cyclingDistance = 0.0,
    this.cyclingDuration = Duration.zero,
    this.runningDistance = 0.0,
    this.runningDuration = Duration.zero,
    this.totalCalories = 0.0,
  });

  factory TodaySummary.fromSessions(List<SessionModel> sessions) {
    double walkDist = 0, cycleDist = 0, runDist = 0;
    Duration walkDur = Duration.zero,
        cycleDur = Duration.zero,
        runDur = Duration.zero;
    double calories = 0;

    for (final session in sessions) {
      switch (session.activityType) {
        case ActivityType.walking:
          walkDist += session.totalDistance;
          walkDur += session.duration;
          break;
        case ActivityType.cycling:
          cycleDist += session.totalDistance;
          cycleDur += session.duration;
          break;
        case ActivityType.running:
          runDist += session.totalDistance;
          runDur += session.duration;
          break;
      }
      calories += session.caloriesBurned;
    }

    return TodaySummary(
      walkingDistance: walkDist,
      walkingDuration: walkDur,
      cyclingDistance: cycleDist,
      cyclingDuration: cycleDur,
      runningDistance: runDist,
      runningDuration: runDur,
      totalCalories: calories,
    );
  }

  String formatDuration(Duration d) {
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}
