import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../view_models/onboarding_view_model.dart';
import 'height.dart';

class AgePage extends StatefulWidget {
  const AgePage({super.key});

  @override
  State<AgePage> createState() => _AgePageState();
}

class _AgePageState extends State<AgePage> {
  late int selectedAge;

  @override
  void initState() {
    super.initState();
    final vm = context.read<OnboardingViewModel>();
    selectedAge = vm.age ?? minAge;
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OnboardingViewModel>();

    return Scaffold(
      backgroundColor: const Color(colorBackground),
      appBar: AppBar(
        title: const Text(
          'What is your age?',
          style: TextStyle(fontSize: textSizeLarge),
        ),
        centerTitle: true,
        foregroundColor: const Color(colorTextSecondary),
        backgroundColor: const Color(colorBackground),
      ),
      body: Column(
        children: [
          const Spacer(),
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
          Container(
            height: 70,
            width: 170,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(colorPrimaryDark),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Text(
              '$selectedAge',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 220,
            height: 66,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(colorPrimary),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Age',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 19.48,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 24),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: agePickerHeight,
            width: 220,
            color: const Color(colorSecondary),
            child: ListWheelScrollView.useDelegate(
              itemExtent: agePickerItemExtent,
              diameterRatio: 2.0,
              useMagnifier: true,
              magnification: 1.2,
              overAndUnderCenterOpacity: 0.4,
              physics: const FixedExtentScrollPhysics(),
              perspective: 0.003,
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  final age = minAge + index;
                  return Center(
                    child: Text(
                      '$age',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 19.48,
                        color: (selectedAge == age)
                            // ignore: deprecated_member_use
                            ? Color(0xFFFFFFFF).withOpacity(
                                0.6,
                              ) // 60% opacity for selected
                            // ignore: deprecated_member_use
                            : Color(colorTextSecondary).withOpacity(1.0),
                      ),
                    ),
                  );
                },
                childCount: maxAge - minAge + 1,
              ),
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedAge = minAge + index;
                  vm.setAge(selectedAge);
                });
              },
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(24.0),
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
                    size: 16,
                  ),
                  label: const Text(
                    'Back',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final error = vm.validateStep(2);
                    if (error == null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HeightPage(),
                        ),
                      );
                    }
                  },
                  child: const Row(
                    children: [
                      Text(
                        'Next',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
