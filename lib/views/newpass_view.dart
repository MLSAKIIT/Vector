import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/auth_view_model.dart';
import 'login_view.dart';

class NewPasswordPage extends StatefulWidget {
  final String code;
  final String email;

  const NewPasswordPage({super.key, required this.code, required this.email});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();

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
                    MaterialPageRoute(builder: (context) => const LoginView()),
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

            const SizedBox(height: 90),

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

                  const SizedBox(height: 35),

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
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                    decoration: _inputDecoration('Password'),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                    decoration: _inputDecoration('Confirm password'),
                  ),

                  const SizedBox(height: 20),

                  if (authVM.error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        authVM.error!,
                        style: const TextStyle(color: Colors.redAccent),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  const SizedBox(height: 60),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF693298),
                      fixedSize: const Size(190, 63),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onPressed: authVM.isLoading
                        ? null
                        : () async {
                            final password = _passwordController.text.trim();
                            final confirmPassword = _confirmPasswordController
                                .text
                                .trim();

                            if (password != confirmPassword) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Passwords do not match'),
                                ),
                              );
                              return;
                            }

                            if (password.length < 6) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Password must be at least 6 characters',
                                  ),
                                ),
                              );
                              return;
                            }

                            final success = await authVM.confirmNewPassword(
                              code: widget.code,
                              newPassword: password,
                            );

                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Password reset successful!'),
                                ),
                              );
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginView(),
                                ),
                                (route) => false,
                              );
                            }
                          },
                    child: authVM.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
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
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      filled: true,
      fillColor: const Color(0xFF2A2438),
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
    );
  }
}
