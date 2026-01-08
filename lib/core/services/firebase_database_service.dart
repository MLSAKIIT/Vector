import 'package:firebase_database/firebase_database.dart';
import '../../models/onboarding_data_model.dart';
import '../constants.dart';

class FirebaseDatabaseService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  DatabaseReference get _usersRef => _database.ref(usersPath);
  DatabaseReference get _onboardingRef => _database.ref(onboardingPath);

  Future<void> saveOnboardingData(
    String userId,
    OnboardingDataModel data,
  ) async {
    // Auto-add timestamps if not present
    final dataWithMeta = data.copyWith(
      userId: userId,
      createdAt: data.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _onboardingRef.child(userId).set(dataWithMeta.toJson());
  }

  Future<OnboardingDataModel?> getOnboardingData(String userId) async {
    final snapshot = await _onboardingRef.child(userId).get();

    if (!snapshot.exists || snapshot.value == null) {
      return null;
    }

    final data = Map<String, dynamic>.from(snapshot.value as Map);
    return OnboardingDataModel.fromJson(data);
  }

  Future<void> updateOnboardingField(
    String userId,
    Map<String, dynamic> updates,
  ) async {
    updates['updatedAt'] = DateTime.now().toIso8601String();
    await _onboardingRef.child(userId).update(updates);
  }

  Future<void> deleteOnboardingData(String userId) async {
    await _onboardingRef.child(userId).remove();
  }

  Future<bool> hasCompletedOnboarding(String userId) async {
    final data = await getOnboardingData(userId);
    if (data == null) return false;

    // All 5 onboarding steps must be filled
    return data.gender != null &&
        data.age != null &&
        data.height != null &&
        data.weight != null &&
        data.goals != null &&
        data.goals!.isNotEmpty;
  }

  Future<ConnectionTestResult> testConnection() async {
    try {
      // Write test data, read it back, then cleanup
      final testData = {
        'test': true,
        'timestamp': DateTime.now().toIso8601String(),
      };
      final testNodeRef = _database.ref(connectionTestPath);
      await testNodeRef.set(testData);

      final readBack = await testNodeRef.get();
      if (!readBack.exists) {
        return ConnectionTestResult(
          success: false,
          message: 'Write succeeded but read failed',
        );
      }

      await testNodeRef.remove();

      return ConnectionTestResult(
        success: true,
        message: 'Connection test passed: Write and read successful',
      );
    } catch (e) {
      return ConnectionTestResult(
        success: false,
        message: 'Connection test failed: $e',
      );
    }
  }
}

class ConnectionTestResult {
  final bool success;
  final String message;

  ConnectionTestResult({required this.success, required this.message});

  @override
  String toString() =>
      'ConnectionTestResult(success: $success, message: $message)';
}
