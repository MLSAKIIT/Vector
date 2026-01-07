import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/auth_view_model.dart';
import '../models/forget_password_model.dart';
import '../views/home_view.dart';
import '../views/age.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool rememberMe = true;

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0F),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 60),

                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 29,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),

                const SizedBox(height: 55),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      const Text(
                        '"Discipline is the bridge between goals and accomplishment" - Jim Rohn',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                        ),
                      ),

                      const SizedBox(height: 70),

                      _label('Email'),
                      _input(
                        controller: _emailController,
                        hint: 'user@email.com',
                      ),

                      const SizedBox(height: 20),

                      _label('Password'),
                      _input(
                        controller: _passwordController,
                        hint: 'password',
                        isPassword: true,
                      ),

                      const SizedBox(height: 15),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () => setState(() => rememberMe = !rememberMe),
                            child: Row(
                              children: [
                                Icon(
                                  rememberMe
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'Remember me',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ForgetPasswordPage(),
                                ),
                              );
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF693298),
                          fixedSize: const Size(244, 63),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: authVM.isLoading
                            ? null
                            : () async {
                                await authVM.login(
                                  email: _emailController.text.trim(),
                                  password:
                                      _passwordController.text.trim(),
                                );

                                if (authVM.error == null) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const AgePage(),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(authVM.error!),
                                    ),
                                  );
                                }
                              },
                        child: authVM.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Log-in',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                      ),

                      const SizedBox(height: 20),

                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          "Don't have an account ? Sign Up !",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Poppins',
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
      ),
    );
  }

  Widget _label(String text) => Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
      );

  Widget _input({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFF2A2438),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
