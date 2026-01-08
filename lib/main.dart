import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view_models/home_view_model.dart';
import 'view_models/onboarding_view_model.dart';
import 'view_models/auth_view_model.dart';
import 'view_models/session_view_model.dart';
import 'view_models/profile_view_model.dart';
import 'core/services/firebase_service.dart';
import 'core/utils/firebase_test_util.dart';
import 'widgets/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();

  // Run Firebase tests in debug mode
  assert(() {
    FirebaseTestUtil.runAllTests();
    return true;
  }());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => OnboardingViewModel()),
        ChangeNotifierProvider(create: (_) => SessionViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
      ],
      child: MaterialApp(
        title: 'Vector',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}
