import 'package:flutter/material.dart';
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
      backgroundColor:  Color(0xFF0B0B0F),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 50),

            const Text(
              'Welcome Back',
              style: TextStyle(
                color: Colors.white,
                fontSize: 29,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),

            const SizedBox(height: 80),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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

                  const SizedBox(height: 150),

                  const Text(
                    'Username',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      color: Color(0xFFF5F5F5),
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

                  const SizedBox(height: 40),

                  const Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      color: Color(0xFFF5F5F5),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
