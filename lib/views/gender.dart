import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../view_models/onboarding_view_model.dart';
import '../models/onboarding_data_model.dart';
import 'age.dart';

class GenderPage extends StatefulWidget {
  const GenderPage({super.key});

  @override
  State<GenderPage> createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  Gender? selectedGender;

  @override
  void initState() {
    super.initState();
    final vm = context.read<OnboardingViewModel>();
    selectedGender = vm.gender;
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OnboardingViewModel>();

    return Scaffold(
      backgroundColor: const Color(colorBackground),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Column(
              children: [
                if (vm.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: paddingMedium),
                    child: Text(
                      vm.errorMessage!,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: textSizeSmall,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const Text(
                  'How do you Identify?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: textSizeLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(colorSecondary),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      _buildOption(Gender.male, Icons.male, "Male"),
                      const SizedBox(height: 20),
                      _buildOption(Gender.female, Icons.female, "Female"),
                      const SizedBox(height: 20),
                      _buildOption(Gender.others, Icons.transgender, "Others"),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Row(
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
                        'Back',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: textSizeMedium,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        final error = vm.validateStep(1);
                        if (error == null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AgePage(),
                            ),
                          );
                        }
                      },
                      child: const Row(
                        children: [
                          Text(
                            'Next',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: textSizeMedium,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: iconSizeSmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOption(Gender gender, IconData icon, String label) {
    bool isSelected = selectedGender == gender;
    return GestureDetector(
      onTap: () {
        setState(() => selectedGender = gender);
        final vm = context.read<OnboardingViewModel>();
        vm.setGender(gender);
      },
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(colorPrimary)
              : const Color(colorPrimaryDark),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 50),
              const SizedBox(height: 10),
              Text(label, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
