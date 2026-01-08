import 'package:firebase_database/firebase_database.dart';
import 'package:vector/models/session_tracking_model.dart';
import 'package:vector/core/constants.dart';
import 'package:vector/core/services/firebase_service.dart';

/// Service for managing session data in Firebase Realtime Database
class SessionService {
  final FirebaseDatabase _database = FirebaseService.instance.database;

  DatabaseReference get _sessionsRef => _database.ref(sessionsPath);

  /// Start a new session
  Future<String> startSession({
    required String userId,
    required ActivityType activityType,
  }) async {
    final session = SessionModel(
      userId: userId,
      activityType: activityType,
      startTime: DateTime.now(),
      isActive: true,
    );

    final newRef = _sessionsRef.child(userId).push();
    await newRef.set(session.toJson());
    return newRef.key!;
  }

  /// Update session with new location data
  Future<void> updateSession({
    required String userId,
    required String sessionId,
    required SessionModel session,
  }) async {
    await _sessionsRef.child(userId).child(sessionId).update(session.toJson());
  }

  /// End a session
  Future<void> endSession({
    required String userId,
    required String sessionId,
    required SessionModel session,
  }) async {
    final endedSession = session.copyWith(
      endTime: DateTime.now(),
      isActive: false,
    );
    await _sessionsRef
        .child(userId)
        .child(sessionId)
        .set(endedSession.toJson());
  }

  /// Get all sessions for a user
  Future<List<SessionModel>> getUserSessions(String userId) async {
    final snapshot = await _sessionsRef.child(userId).get();

    if (!snapshot.exists || snapshot.value == null) {
      return [];
    }

    final data = Map<String, dynamic>.from(snapshot.value as Map);
    return data.entries.map((e) {
      return SessionModel.fromJson(
        Map<String, dynamic>.from(e.value),
        id: e.key,
      );
    }).toList();
  }

  /// Get today's sessions for a user
  Future<List<SessionModel>> getTodaySessions(String userId) async {
    final allSessions = await getUserSessions(userId);
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);

    return allSessions.where((s) => s.startTime.isAfter(startOfDay)).toList();
  }

  /// Get sessions for a specific date range
  Future<List<SessionModel>> getSessionsInRange(
    String userId, {
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final allSessions = await getUserSessions(userId);
    return allSessions
        .where(
          (s) =>
              s.startTime.isAfter(startDate) &&
              s.startTime.isBefore(endDate.add(const Duration(days: 1))),
        )
        .toList()
      ..sort((a, b) => b.startTime.compareTo(a.startTime)); // Most recent first
  }

  /// Get sessions for the past week
  Future<List<SessionModel>> getWeekSessions(String userId) async {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    return getSessionsInRange(userId, startDate: weekAgo, endDate: now);
  }

  /// Get sessions for the past month
  Future<List<SessionModel>> getMonthSessions(String userId) async {
    final now = DateTime.now();
    final monthAgo = DateTime(now.year, now.month - 1, now.day);
    return getSessionsInRange(userId, startDate: monthAgo, endDate: now);
  }

  /// Get sessions for the past year
  Future<List<SessionModel>> getYearSessions(String userId) async {
    final now = DateTime.now();
    final yearAgo = DateTime(now.year - 1, now.month, now.day);
    return getSessionsInRange(userId, startDate: yearAgo, endDate: now);
  }

  /// Get the active session if any
  Future<SessionModel?> getActiveSession(String userId) async {
    final sessions = await getUserSessions(userId);
    try {
      return sessions.firstWhere((s) => s.isActive);
    } catch (_) {
      return null;
    }
  }

  /// Delete a session
  Future<void> deleteSession({
    required String userId,
    required String sessionId,
  }) async {
    await _sessionsRef.child(userId).child(sessionId).remove();
  }

  /// Calculate calories burned based on activity type and distance
  static double calculateCalories({
    required ActivityType activityType,
    required double distanceMeters,
    required double weightKg,
  }) {
    // MET values (Metabolic Equivalent of Task)
    // Walking: 3.5 MET, Running: 9.8 MET, Cycling: 7.5 MET
    double met;
    switch (activityType) {
      case ActivityType.walking:
        met = 3.5;
        break;
      case ActivityType.running:
        met = 9.8;
        break;
      case ActivityType.cycling:
        met = 7.5;
        break;
    }

    // Estimate duration based on average speeds
    // Walking: 5 km/h, Running: 10 km/h, Cycling: 20 km/h
    double avgSpeedKmh;
    switch (activityType) {
      case ActivityType.walking:
        avgSpeedKmh = 5.0;
        break;
      case ActivityType.running:
        avgSpeedKmh = 10.0;
        break;
      case ActivityType.cycling:
        avgSpeedKmh = 20.0;
        break;
    }

    final distanceKm = distanceMeters / 1000;
    final durationHours = distanceKm / avgSpeedKmh;

    // Calories = MET × weight (kg) × time (hours)
    return met * weightKg * durationHours;
  }
}
