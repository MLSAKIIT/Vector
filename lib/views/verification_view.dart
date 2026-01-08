import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pinput/pinput.dart';
import '../view_models/auth_view_model.dart';
import 'forgetpass_view.dart';
import 'newpass_view.dart';

class VerificationPage extends StatefulWidget {
  final String email;

  const VerificationPage({super.key, required this.email});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  String _code = '';

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();
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
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgetPasswordPage(),
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
              const SizedBox(height: 120), // space from top
              // 🔹 Top Image
              Image.asset(
                'assets/images/verification_page.png',
                height: 144,
                width: 155,
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
                    Text(
                      'Verification code sent to ${widget.email}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Pinput to store code
                    Pinput(
                      length: 6,
                      defaultPinTheme: defaultPinTheme,
                      onChanged: (value) {
                        setState(() => _code = value);
                      },
                      onCompleted: (value) {
                        setState(() => _code = value);
                      },
                    ),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: authVM.isLoading
                          ? null
                          : () async {
                              await authVM.resetPassword(email: widget.email);
                              if (authVM.error == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Verification code resent!'),
                                  ),
                                );
                              }
                            },
                      child: const Text(
                        'Resend Email?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    const SizedBox(height: 90),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF693298),
                        fixedSize: const Size(190, 63),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: authVM.isLoading || _code.length < 6
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewPasswordPage(
                                    code: _code,
                                    email: widget.email,
                                  ),
                                ),
                              );
                            },
                      child: authVM.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Verify',
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
