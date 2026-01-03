import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:newapp/forget_password/forget_password_view.dart';
import 'package:newapp/login/login_view/login_view.dart';
import 'package:newapp/new_password/new_password_view.dart';
import 'package:newapp/verification_page/verification_page_view.dart';
=======
import 'package:provider/provider.dart';

import 'view_models/home_view_model.dart';
>>>>>>> upstream/main

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:LoginView(),
=======
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => HomeViewModel())],
      child: MaterialApp(
        title: 'Vector',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Scaffold(body: Center(child: Text('Vector'))),
      ),
>>>>>>> upstream/main
    );
  }
}
