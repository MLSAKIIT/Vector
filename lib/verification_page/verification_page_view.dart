import 'package:flutter/material.dart';
import 'package:newapp/new_password/new_password_view.dart';
import 'package:pinput/pinput.dart';
import 'verification_page_viewmodel.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final VerificationViewModel viewModel = VerificationViewModel();
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 35,
      height: 45,
      textStyle: const TextStyle(
        fontSize: 32,
        color: Colors.white,
        fontWeight: FontWeight.w400,
        fontFamily: 'Poppins',
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2438),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0F),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 80), // space from top

              // 🔹 Top Image
              Image.asset(
                'assets/images/verification_page.png',
                height: 144,
                width:155,
              ),

              const SizedBox(height: 40), // space between image and text

              // Title
              const Center(
                child: Text(
                  'Verify email address',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Description + Pinput
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    const Text(
                      'Verification code sent on',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Pinput to store code
                    Pinput(
                      length: 4,
                      defaultPinTheme: defaultPinTheme,
                      onChanged: (value) {
                        // Store the entered code in ViewModel
                        viewModel.setCode(value);

                      },
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'Resend Email? ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF693298),
                        fixedSize: const Size(190, 63),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NewPasswordPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'verify',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),


                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
