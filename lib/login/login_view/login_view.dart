import 'package:flutter/material.dart';
import 'package:newapp/forget_password/forget_password_view.dart';
import '../login_view_model/login_view_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginViewModel viewModel = LoginViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0F),
      body: SafeArea(
        child: Center( // 🔹 centers everything vertically + horizontally
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // 🔹 vertical center
              crossAxisAlignment: CrossAxisAlignment.center, // 🔹 horizontal center
              children: [
                const SizedBox(height: 50),

                const Text(
                  'Welcome Back!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 29,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),

                const SizedBox(height: 60),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center, // 🔹 center inside
                    children: [

                      const Text(
                        '"Discipline is the bridge between goals and accomplishment" - Jim Rohn',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                        ),
                      ),

                      const SizedBox(height: 70),

                      const Align(
                        alignment: Alignment.centerLeft, // labels stay readable
                        child: Text(
                          'Username',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                            color: Color(0xFFF5F5F5),
                          ),
                        ),
                      ),

                      TextField(
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: 'username',
                          hintStyle: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'Poppins',
                            color: Color(0xFFAAA7AF),
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
                        onChanged: (value) {
                          viewModel.updateUsername(value);
                        },
                      ),

                      const SizedBox(height: 20),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Password',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                            color: Color(0xFFF5F5F5),
                          ),
                        ),
                      ),

                      TextField(
                        obscureText: true,
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: 'password',
                          hintStyle: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'Poppins',
                            color: Color(0xFFAAA7AF),
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
                        onChanged: (value) {
                          viewModel.updatePassword(value);
                        },
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgetPasswordPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Log-in',
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
      ),
    );
  }
  }
