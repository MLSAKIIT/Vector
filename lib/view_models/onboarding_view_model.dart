import 'package:flutter/foundation.dart';
import '../core/services/firebase_database_service.dart';
import '../models/onboarding_data_model.dart';

enum OnboardingError { saveFailed, loadFailed, networkError }

class OnboardingViewModel extends ChangeNotifier {
  final FirebaseDatabaseService _db = FirebaseDatabaseService();

  Gender? _gender;
  int? _age;
  int? _height;
  String _heightUnit = 'cm';
  int? _weight;
  String _weightUnit = 'kg';
  List<FitnessGoal> _goals = [];

  bool _isSaving = false;
  OnboardingError? _errorType;

  Gender? get gender => _gender;
  int? get age => _age;
  int? get height => _height;
  String get heightUnit => _heightUnit;
  int? get weight => _weight;
  String get weightUnit => _weightUnit;
  List<FitnessGoal> get goals => List.unmodifiable(_goals);
  bool get isSaving => _isSaving;
  OnboardingError? get errorType => _errorType;

  bool get hasBasicInfo => _gender != null && _age != null;
  bool get hasPhysicalInfo => _height != null && _weight != null;
  bool get isComplete => hasBasicInfo && hasPhysicalInfo && _goals.isNotEmpty;

  String? get errorMessage {
    if (_errorType == null) return null;
    switch (_errorType!) {
      case OnboardingError.saveFailed:
        return 'Could not save your data. Please try again.';
      case OnboardingError.loadFailed:
        return 'Could not load your profile.';
      case OnboardingError.networkError:
        return 'Network error. Check your connection.';
    }
  }

  void setGender(Gender gender) {
    if (_gender == gender) return;
    _gender = gender;
    _clearError();
    notifyListeners();
  }

  void setAge(int age) {
    if (!_isValidAge(age)) return;
    _age = age;
    notifyListeners();
  }

  void setHeight(int height, {String? unit}) {
    _height = height;
    if (unit != null) _heightUnit = unit;
    notifyListeners();
  }

  void setWeight(int weight, {String? unit}) {
    _weight = weight;
    if (unit != null) _weightUnit = unit;
    notifyListeners();
  }

  void toggleGoal(FitnessGoal goal) {
    _goals.contains(goal) ? _goals.remove(goal) : _goals.add(goal);
    notifyListeners();
  }

  bool _isValidAge(int age) => age >= 13 && age <= 120;

  String? validateStep(int step) {
    switch (step) {
      case 1:
        return _gender == null ? 'Please select your gender' : null;
      case 2:
        if (_age == null) return 'Please enter your age';
        if (!_isValidAge(_age!)) return 'Age must be between 13 and 120';
        return null;
      case 3:
        return _height == null ? 'Please enter your height' : null;
      case 4:
        return _weight == null ? 'Please enter your weight' : null;
      case 5:
        return _goals.isEmpty ? 'Select at least one goal' : null;
      default:
        return null;
    }
  }

  Future<bool> save(String userId) async {
    if (!isComplete) return false;

    _isSaving = true;
    _clearError();
    notifyListeners();

    try {
      final data = OnboardingDataModel(
        gender: _gender,
        age: _age,
        height: _height,
        heightUnit: _heightUnit,
        weight: _weight,
        weightUnit: _weightUnit,
        goals: _goals,
      );

      await _db.saveOnboardingData(userId, data);
      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorType = OnboardingError.saveFailed;
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> load(String userId) async {
    _isSaving = true;
    notifyListeners();

    try {
      final data = await _db.getOnboardingData(userId);
      if (data != null) {
        _gender = data.gender;
        _age = data.age;
        _height = data.height;
        _heightUnit = data.heightUnit ?? 'cm';
        _weight = data.weight;
        _weightUnit = data.weightUnit ?? 'kg';
        _goals = data.goals ?? [];
      }
      _isSaving = false;
      notifyListeners();
      return data != null;
    } catch (e) {
      _errorType = OnboardingError.loadFailed;
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() => _clearError();

  void reset() {
    _gender = null;
    _age = null;
    _height = null;
    _heightUnit = 'cm';
    _weight = null;
    _weightUnit = 'kg';
    _goals = [];
    _clearError();
    notifyListeners();
  }

  void _clearError() {
    if (_errorType != null) {
      _errorType = null;
      notifyListeners();
    }
  }
}
