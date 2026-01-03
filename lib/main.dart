import 'package:flutter/material.dart';
import 'package:newapp/forget_password/forget_password_view.dart';
import 'package:newapp/login/login_view/login_view.dart';
import 'package:newapp/new_password/new_password_view.dart';
import 'package:newapp/verification_page/verification_page_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:LoginView(),
    );
  }
}
