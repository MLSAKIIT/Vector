import 'package:flutter/material.dart';
import 'package:newapp/login/login_view/login_view.dart';
import 'package:newapp/verification_page/verification_page_view.dart';
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
            Align(
            alignment: Alignment.centerLeft,
            child:InkWell(
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
              const SizedBox(height: 110),
              Image.asset(
                'assets/images/forget_password_page.png',
                height: 144,
                width:155,
              ),
              const SizedBox(height: 40),
              // 🔹 Title
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
                    const SizedBox(height: 100),
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
                            builder: (context) => const VerificationPage(),
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
      ),
    );
  }
}
