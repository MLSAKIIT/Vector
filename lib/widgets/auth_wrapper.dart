import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/services/firebase_service.dart';
import '../core/services/firebase_database_service.dart';
import '../views/register_view.dart';
import '../views/gender.dart';
import '../views/home_view.dart';

/// AuthWrapper - Routes users based on authentication and onboarding status.
///
/// Flow:
/// - Not logged in → RegisterView
/// - Logged in + Onboarding incomplete → GenderPage (start onboarding)
/// - Logged in + Onboarding complete → HomeView
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseService.instance.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF0B0B0F),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF693298)),
            ),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          // Check if user has completed onboarding
          return _OnboardingCheckWrapper(userId: snapshot.data!.uid);
        }

        return RegisterView();
      },
    );
  }
}

/// Checks if user has completed onboarding and routes accordingly
class _OnboardingCheckWrapper extends StatelessWidget {
  final String userId;

  const _OnboardingCheckWrapper({required this.userId});

  @override
  Widget build(BuildContext context) {
    final databaseService = FirebaseDatabaseService();

    return FutureBuilder<bool>(
      future: databaseService.hasCompletedOnboarding(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF0B0B0F),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF693298)),
            ),
          );
        }

        // If onboarding is complete, go to HomeView
        if (snapshot.hasData && snapshot.data == true) {
          return const HomeView();
        }

        // Otherwise, start onboarding
        return const GenderPage();
      },
    );
  }
}
