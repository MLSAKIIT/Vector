import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../view_models/onboarding_view_model.dart';
import 'weight.dart';

class HeightPage extends StatefulWidget {
  const HeightPage({super.key});

  @override
  State<HeightPage> createState() => _HeightPageState();
}

class _HeightPageState extends State<HeightPage> {
  late int selectedHeight;
  String selectedUnit = 'cm';

  @override
  void initState() {
    super.initState();
    final vm = context.read<OnboardingViewModel>();
    selectedHeight = vm.height ?? minHeight;
    selectedUnit = vm.heightUnit;
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OnboardingViewModel>();

    return Scaffold(
      backgroundColor: const Color(colorBackground),
      appBar: AppBar(
        title: const Text(
          'What is your Height?',
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
              '$selectedHeight',
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  selectedUnit,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 19.48,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.keyboard_arrow_up,
                  color: Colors.white,
                  size: 24,
                ),
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
                  final height = minHeight + index;
                  return Center(
                    child: Text(
                      '$height',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 19.48,
                        color: (selectedHeight == height)
                            ? const Color(0xFFFFFFFF).withOpacity(0.6)
                            : const Color(colorTextSecondary).withOpacity(1.0),
                      ),
                    ),
                  );
                },
                childCount: maxHeight - minHeight + 1,
              ),
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedHeight = minHeight + index;
                  vm.setHeight(selectedHeight, unit: selectedUnit);
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
                    final error = vm.validateStep(3);
                    if (error == null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WeightPage(),
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
