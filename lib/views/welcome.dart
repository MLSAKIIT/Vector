import 'package:flutter/material.dart';
import '../core/constants.dart';
import 'gender.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(colorBackground),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: paddingLarge),
          child: Column(
            children: [
              const Spacer(),

              Image.asset(
                'assets/Group_111.png',
                height: MediaQuery.of(context).size.height * 0.35,
              ),

              const SizedBox(height: 32),

              const Text(
                'Energize your lives with',
                style: TextStyle(
                  color: Color(colorTextPrimary),
                  fontSize: textSizeMedium,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Vector!',
                style: TextStyle(
                  color: Color(colorAccent),
                  fontSize: textSizeXLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GenderPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(colorPrimary),
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadiusButton),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: textSizeMedium,
                      color: Color(colorTextSecondary),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Join us for a better lifestyle!',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: textSizeSmall,
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
