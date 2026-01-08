import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_service.dart';

/// Firebase Authentication Service
/// Uses the central FirebaseService instance for all auth operations.
class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseService.instance.auth;

  User? get currentUser => _auth.currentUser;

  bool get isAuthenticated => currentUser != null;

  String? get userId => currentUser?.uid;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> confirmPasswordReset({
    required String code,
    required String newPassword,
  }) async {
    await _auth.confirmPasswordReset(code: code, newPassword: newPassword);
  }

  Future<void> updatePassword({required String newPassword}) async {
    await currentUser?.updatePassword(newPassword);
  }

  Future<void> sendEmailVerification() async {
    await currentUser?.sendEmailVerification();
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> deleteAccount() async {
    await currentUser?.delete();
  }
}
