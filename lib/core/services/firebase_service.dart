import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

/// Central Firebase service that provides singleton instances
/// of all Firebase services used in the app.
///
/// This ensures we use pre-initialized instances and avoid
/// creating multiple connections to Firebase.
class FirebaseService {
  // Private constructor for singleton pattern
  FirebaseService._();

  // Singleton instance
  static final FirebaseService _instance = FirebaseService._();
  static FirebaseService get instance => _instance;

  // Firebase instances (lazy initialized after Firebase.initializeApp())
  FirebaseAuth? _auth;
  FirebaseDatabase? _database;

  /// Initialize Firebase and cache the instances
  static Future<void> initialize() async {
    await Firebase.initializeApp();
    _instance._auth = FirebaseAuth.instance;
    _instance._database = FirebaseDatabase.instance;
  }

  /// Get the FirebaseAuth instance
  FirebaseAuth get auth {
    if (_auth == null) {
      throw Exception(
        'FirebaseService not initialized. Call FirebaseService.initialize() first.',
      );
    }
    return _auth!;
  }

  /// Get the FirebaseDatabase instance
  FirebaseDatabase get database {
    if (_database == null) {
      throw Exception(
        'FirebaseService not initialized. Call FirebaseService.initialize() first.',
      );
    }
    return _database!;
  }

  // Convenience getters
  User? get currentUser => auth.currentUser;
  bool get isAuthenticated => currentUser != null;
  String? get userId => currentUser?.uid;
  Stream<User?> get authStateChanges => auth.authStateChanges();
}
