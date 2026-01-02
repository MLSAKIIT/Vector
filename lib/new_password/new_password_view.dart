import 'package:flutter/material.dart';
import 'new_password_viewmodel.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final NewPasswordViewModel viewModel = NewPasswordViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0F),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 290),

              // Title
              const Center(
                child: Text(
                  'New Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),

              const SizedBox(height: 40),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    const Text(
                      'Enter your new password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                      ),
                    ),

                    const SizedBox(height: 40),

                    // New Password
                    TextField(
                      obscureText: true,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                      decoration: _inputDecoration('Password'),
                      onChanged: viewModel.setPassword,
                    ),

                    const SizedBox(height: 20),

                    // Confirm Password
                    TextField(
                      obscureText: true,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                      decoration: _inputDecoration('Confirm password'),
                      onChanged: viewModel.setConfirmPassword,
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

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
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
    );
  }
}
