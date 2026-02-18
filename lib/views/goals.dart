import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../view_models/onboarding_view_model.dart';
import '../view_models/auth_view_model.dart';
import '../models/onboarding_data_model.dart';
import 'home_view.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  Set<FitnessGoal> selectedGoals = {};

  @override
  void initState() {
    super.initState();
    final vm = context.read<OnboardingViewModel>();
    selectedGoals = Set.from(vm.goals);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OnboardingViewModel>();

    return Scaffold(
      backgroundColor: const Color(colorBackground),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 64),
            if (vm.errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: paddingLarge),
                child: Text(
                  vm.errorMessage!,
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: textSizeSmall,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: paddingMedium),
            const Text(
              "What are your Goals?",
              style: TextStyle(
                color: Colors.white,
                fontSize: textSizeLarge,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 56),
            Container(
              height: 504,
              width: 323,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 22),
              decoration: BoxDecoration(
                color: const Color(colorSecondary).withOpacity(0.5),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: _buildGoalTile(
                      vm,
                      FitnessGoal.gainWeight,
                      "Gain Weight",
                    ),
                  ),
                  Expanded(
                    child: _buildGoalTile(
                      vm,
                      FitnessGoal.loseWeight,
                      "Lose Weight",
                    ),
                  ),
                  Expanded(
                    child: _buildGoalTile(
                      vm,
                      FitnessGoal.muscleGain,
                      "Muscle Gain",
                    ),
                  ),
                  Expanded(
                    child: _buildGoalTile(
                      vm,
                      FitnessGoal.betterEndurance,
                      "Better Endurance",
                    ),
                  ),
                  Expanded(
                    child: _buildGoalTile(vm, FitnessGoal.others, "Others"),
                  ),
                ],
              ),
            ),

            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: iconSizeSmall,
                    ),
                    label: const Text(
                      "Back",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: textSizeMedium,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final error = vm.validateStep(5);
                      if (error == null && vm.isComplete) {
                        final authVM = context.read<AuthViewModel>();
                        final userId = authVM.userId;

                        if (userId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please login first')),
                          );
                          return;
                        }

                        final success = await vm.save(userId);
                        if (success && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Onboarding completed successfully!',
                              ),
                            ),
                          );
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const HomeView()),
                            (route) => false,
                          );
                        }
                      }
                    },
                    child: Row(
                      children: [
                        Text(
                          vm.isSaving ? "Saving..." : "Complete",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: textSizeMedium,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: iconSizeSmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalTile(OnboardingViewModel vm, FitnessGoal goal, String text) {
    final isSelected = selectedGoals.contains(goal);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (isSelected) {
              selectedGoals.remove(goal);
            } else {
              selectedGoals.add(goal);
            }
          });
          vm.toggleGoal(goal);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(colorPrimary)
                : const Color(colorPrimaryDark),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontSize: 17.14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: const Color(
                    0xFF261140,
                  ).withOpacity(isSelected ? 1.0 : 0.68),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: const Color(
                      0xFF261140,
                    ).withOpacity(isSelected ? 1.0 : 0.68),
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
