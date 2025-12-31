import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0B0B0F),
      body: SafeArea(
        child: Column(
          children: [

            const SizedBox(height: 50),

            // 🔹 NO padding here
            const Text(
              'Welcome Back',
              style: TextStyle(
                color: Colors.white,
                fontSize: 29,
                fontWeight: FontWeight.w600,

                fontFamily: 'Poppins',
              ),
            ),

            SizedBox(height: 80),

            // 🔹 Padding for rest
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    '"Discipline is the bridge between goals and accomplishment" - Jim Rohn',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,

                      fontSize: 16,
                      fontFamily: 'Poppins',
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 150),
                  Text(
                    'Username',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,

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
                    onChanged: (value) {
                      setState(() {
                        username = value;
                      });
                    },
                  ),

                  const SizedBox(height: 40),
                  Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFF5F5F5),
                    ),
                  ),
                  TextField(
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
                    obscureText: true,
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
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

