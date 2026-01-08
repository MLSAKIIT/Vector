import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/services/firebase_auth_service.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

enum AuthError {
  invalidEmail,
  userNotFound,
  wrongPassword,
  emailInUse,
  weakPassword,
  networkError,
  unknown,
}

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();

  AuthState _state = AuthState.initial;
  AuthError? _errorType;
  String? _resetEmail;

  AuthState get state => _state;
  AuthError? get errorType => _errorType;
  bool get isLoading => _state == AuthState.loading;
  bool get isAuthenticated => _authService.isAuthenticated;
  User? get currentUser => _authService.currentUser;
  String? get userId => _authService.userId;
  String? get resetEmail => _resetEmail;

  String? get error {
    if (_errorType == null) return null;
    switch (_errorType!) {
      case AuthError.invalidEmail:
        return 'Invalid email address.';
      case AuthError.userNotFound:
        return 'No account found with this email.';
      case AuthError.wrongPassword:
        return 'Incorrect password.';
      case AuthError.emailInUse:
        return 'Email is already registered.';
      case AuthError.weakPassword:
        return 'Password is too weak.';
      case AuthError.networkError:
        return 'Network error. Check your connection.';
      case AuthError.unknown:
        return 'An unexpected error occurred.';
    }
  }

  void _setLoading() {
    _state = AuthState.loading;
    _errorType = null;
    notifyListeners();
  }

  void _setAuthenticated() {
    _state = AuthState.authenticated;
    _errorType = null;
    notifyListeners();
  }

  void _setUnauthenticated() {
    _state = AuthState.unauthenticated;
    notifyListeners();
  }

  void _setError(AuthError error) {
    _state = AuthState.error;
    _errorType = error;
    notifyListeners();
  }

  AuthError _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return AuthError.invalidEmail;
      case 'user-not-found':
        return AuthError.userNotFound;
      case 'wrong-password':
        return AuthError.wrongPassword;
      case 'email-already-in-use':
        return AuthError.emailInUse;
      case 'weak-password':
        return AuthError.weakPassword;
      case 'network-request-failed':
        return AuthError.networkError;
      default:
        return AuthError.unknown;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      _setError(AuthError.invalidEmail);
      return false;
    }

    _setLoading();

    try {
      await _authService.signUp(email: email, password: password);
      _setAuthenticated();
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_mapFirebaseError(e));
      return false;
    } catch (e) {
      _setError(AuthError.unknown);
      return false;
    }
  }

  Future<bool> login({required String email, required String password}) async {
    if (email.isEmpty || password.isEmpty) {
      _setError(AuthError.invalidEmail);
      return false;
    }

    _setLoading();

    try {
      await _authService.signIn(email: email, password: password);
      _setAuthenticated();
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_mapFirebaseError(e));
      return false;
    } catch (e) {
      _setError(AuthError.unknown);
      return false;
    }
  }

  Future<bool> resetPassword({required String email}) async {
    if (email.isEmpty) {
      _setError(AuthError.invalidEmail);
      return false;
    }

    _setLoading();
    _resetEmail = email;

    try {
      await _authService.sendPasswordResetEmail(email: email);
      _state = AuthState.unauthenticated;
      _errorType = null;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_mapFirebaseError(e));
      return false;
    } catch (e) {
      _setError(AuthError.unknown);
      return false;
    }
  }

  Future<bool> confirmNewPassword({
    required String code,
    required String newPassword,
  }) async {
    if (code.isEmpty || newPassword.isEmpty) {
      _setError(AuthError.weakPassword);
      return false;
    }

    _setLoading();

    try {
      await _authService.confirmPasswordReset(
        code: code,
        newPassword: newPassword,
      );
      _setUnauthenticated();
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_mapFirebaseError(e));
      return false;
    } catch (e) {
      _setError(AuthError.unknown);
      return false;
    }
  }

  Future<void> signOut() async {
    _setLoading();
    try {
      await _authService.signOut();
      _setUnauthenticated();
    } catch (e) {
      _setError(AuthError.unknown);
    }
  }

  void clearError() {
    _errorType = null;
    if (_state == AuthState.error) {
      _state = AuthState.unauthenticated;
    }
    notifyListeners();
  }

  void checkAuthState() {
    if (_authService.isAuthenticated) {
      _setAuthenticated();
    } else {
      _setUnauthenticated();
    }
  }
}
