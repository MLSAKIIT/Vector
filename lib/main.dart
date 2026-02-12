import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vector/views/leader.dart';
import 'view_models/home_view_model.dart';
import 'views/leaderboard.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
      ],
      child: MaterialApp(
        title: 'Fitness Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark, 
          useMaterial3: true,
        ),
        home:  Board(), 
      ),
    );
  }
}