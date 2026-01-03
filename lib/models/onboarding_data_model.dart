enum Gender { male, female, others }

enum FitnessGoal { gainWeight, loseWeight, muscleGain, betterEndurance, others }

class OnboardingDataModel {
  final String? userId;
  final Gender? gender;
  final int? age;
  final int? height;
  final String? heightUnit;
  final int? weight;
  final String? weightUnit;
  final List<FitnessGoal>? goals;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OnboardingDataModel({
    this.userId,
    this.gender,
    this.age,
    this.height,
    this.heightUnit = 'cm',
    this.weight,
    this.weightUnit = 'kg',
    this.goals,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'gender': gender?.name,
      'age': age,
      'height': height,
      'heightUnit': heightUnit,
      'weight': weight,
      'weightUnit': weightUnit,
      'goals': goals?.map((g) => g.name).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory OnboardingDataModel.fromJson(Map<String, dynamic> json) {
    return OnboardingDataModel(
      userId: json['userId'] as String?,
      gender: json['gender'] != null
          ? Gender.values.firstWhere(
              (g) => g.name == json['gender'],
              orElse: () => Gender.others,
            )
          : null,
      age: json['age'] as int?,
      height: json['height'] as int?,
      heightUnit: json['heightUnit'] as String? ?? 'cm',
      weight: json['weight'] as int?,
      weightUnit: json['weightUnit'] as String? ?? 'kg',
      goals: (json['goals'] as List<dynamic>?)
          ?.map(
            (g) => FitnessGoal.values.firstWhere(
              (goal) => goal.name == g,
              orElse: () => FitnessGoal.others,
            ),
          )
          .toList(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  OnboardingDataModel copyWith({
    String? userId,
    Gender? gender,
    int? age,
    int? height,
    String? heightUnit,
    int? weight,
    String? weightUnit,
    List<FitnessGoal>? goals,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OnboardingDataModel(
      userId: userId ?? this.userId,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      height: height ?? this.height,
      heightUnit: heightUnit ?? this.heightUnit,
      weight: weight ?? this.weight,
      weightUnit: weightUnit ?? this.weightUnit,
      goals: goals ?? this.goals,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
