import 'package:flutter/foundation.dart';
import '../services/firebase_database_service.dart';
import '../../models/onboarding_data_model.dart';

class FirebaseTestUtil {
  static final FirebaseDatabaseService _service = FirebaseDatabaseService();

  static Future<void> runAllTests() async {
    debugPrint('═══════════════════════════════════════════');
    debugPrint('🔥 Firebase Realtime Database Test Suite');
    debugPrint('═══════════════════════════════════════════\n');

    await _testConnection();
    await _testWriteAndRead();
    await _testUpdate();
    await _testDelete();

    debugPrint('═══════════════════════════════════════════');
    debugPrint('✅ All tests completed');
    debugPrint('═══════════════════════════════════════════');
  }

  static Future<void> _testConnection() async {
    debugPrint('📡 Test 1: Connection Test');
    debugPrint('───────────────────────────────────────────');

    final result = await _service.testConnection();

    if (result.success) {
      debugPrint('   ✅ ${result.message}');
    } else {
      debugPrint('   ❌ ${result.message}');
    }
    debugPrint('');
  }

  static Future<void> _testWriteAndRead() async {
    debugPrint('📝 Test 2: Write and Read');
    debugPrint('───────────────────────────────────────────');

    const testUserId = 'test_user_001';
    final testData = OnboardingDataModel(
      gender: Gender.male,
      age: 25,
      height: 175,
      heightUnit: 'cm',
      weight: 70,
      weightUnit: 'kg',
      goals: [FitnessGoal.muscleGain, FitnessGoal.betterEndurance],
    );

    try {
      await _service.saveOnboardingData(testUserId, testData);
      debugPrint('   ✅ Write successful');

      final readData = await _service.getOnboardingData(testUserId);
      if (readData != null) {
        debugPrint('   ✅ Read successful');
        debugPrint(
          '   📄 Data: Gender=${readData.gender?.name}, Age=${readData.age}',
        );
        debugPrint('   📄 Height=${readData.height}${readData.heightUnit}');
        debugPrint('   📄 Weight=${readData.weight}${readData.weightUnit}');
        debugPrint(
          '   📄 Goals=${readData.goals?.map((g) => g.name).join(", ")}',
        );
      } else {
        debugPrint('   ❌ Read failed: No data returned');
      }
    } catch (e) {
      debugPrint('   ❌ Error: $e');
    }
    debugPrint('');
  }

  static Future<void> _testUpdate() async {
    debugPrint('🔄 Test 3: Update');
    debugPrint('───────────────────────────────────────────');

    const testUserId = 'test_user_001';

    try {
      await _service.updateOnboardingField(testUserId, {'age': 26});
      debugPrint('   ✅ Update successful');

      final updated = await _service.getOnboardingData(testUserId);
      if (updated?.age == 26) {
        debugPrint('   ✅ Verified: Age updated to ${updated?.age}');
      } else {
        debugPrint('   ❌ Update verification failed');
      }
    } catch (e) {
      debugPrint('   ❌ Error: $e');
    }
    debugPrint('');
  }

  static Future<void> _testDelete() async {
    debugPrint('🗑️ Test 4: Delete');
    debugPrint('───────────────────────────────────────────');

    const testUserId = 'test_user_001';

    try {
      await _service.deleteOnboardingData(testUserId);
      debugPrint('   ✅ Delete successful');

      final deleted = await _service.getOnboardingData(testUserId);
      if (deleted == null) {
        debugPrint('   ✅ Verified: Data removed');
      } else {
        debugPrint('   ❌ Delete verification failed');
      }
    } catch (e) {
      debugPrint('   ❌ Error: $e');
    }
    debugPrint('');
  }
}
