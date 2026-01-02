import 'package:flutter/material.dart';
import 'forget_password_viewmodel.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final ForgetPasswordViewModel viewModel = ForgetPasswordViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0F),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 290),

              // 🔹 Title (no padding)
              const Center(
                child: Text(
                  'Forget Password?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // 🔹 Content with padding
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(

                  children: [
                    const Text(
                      'Enter your email to receive a confirmation code to set a new password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                      ),
                    ),

                    const SizedBox(height: 40),

                    TextField(
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: 'user@name.com',
                        hintStyle: const TextStyle(
                          color: Color(0xFFAAA7AF),
                          fontSize: 15,
                          fontFamily: 'Poppins',
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF2A2438),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 20,
                        ),
                      ),
                      onChanged: viewModel.updateEmail,
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
