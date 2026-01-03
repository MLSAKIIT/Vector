import 'package:flutter/material.dart';
import 'package:newapp/login/login_view/login_view.dart';
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
          child: Column(
            children: [

              // Back text
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginView(),
                      ),
                    );
                  },
                  child: const Text(
                    '<Back',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.33,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 120),

              // Main content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Image.asset(
                      'assets/images/new_password_page.png',
                      height: 144,
                      width: 155,
                    ),

                    const SizedBox(height: 40),

                    const Text(
                      'New Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),

                    const SizedBox(height: 40),

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

                    TextField(
                      obscureText: true,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                      decoration: _inputDecoration('Confirm password'),
                      onChanged: viewModel.setConfirmPassword,
                    ),

                    const SizedBox(height: 110),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF693298),
                        fixedSize: const Size(190, 63),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginView(),
                          ),
                        );
                      },
                      child: const Text(
                        'Confirm',
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
