import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/user.dart';

class FirebaseAuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  // Constructor injection allows for easy testing (mocking FirebaseAuth)
  FirebaseAuthService({firebase_auth.FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  // ---------------------------------------------------------------------------
  // Auth State Stream
  // ---------------------------------------------------------------------------
  /// Listens to auth state changes and maps the Firebase User to our Domain User.
  /// Note: This returns a "Partial User" (only ID/Email/Name).
  /// The Repository will be responsible for fetching the full profile (height/weight) from the DB.
  Stream<User?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map(_mapFirebaseUser);
  }

  // ---------------------------------------------------------------------------
  // Core Actions
  // ---------------------------------------------------------------------------

  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _mapFirebaseUser(userCredential.user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      // Architect's Note: We let the Repository handle the conversion to "Failure" objects.
      // Here we just want to ensure the error propagates cleanly.
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  Future<User?> register({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _mapFirebaseUser(userCredential.user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  User? get currentUser => _mapFirebaseUser(_firebaseAuth.currentUser);

  // ---------------------------------------------------------------------------
  // Helper Methods
  // ---------------------------------------------------------------------------

  /// Maps the raw Firebase User to our clean Domain User model.
  User? _mapFirebaseUser(firebase_auth.User? firebaseUser) {
    if (firebaseUser == null) return null;

    return User(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      name: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
      createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
      // We set these to null because Auth Service doesn't know about medical data.
      // The Repository will fetch this info from SQLite/Firestore.
      bloodType: null,
      height: null,
      weight: null,
      isSynced: true, // Data from Firebase Auth is considered "synced"
    );
  }

  Exception _handleAuthException(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('No user found for that email.');
      case 'wrong-password':
        return Exception('Wrong password provided.');
      case 'email-already-in-use':
        return Exception('The account already exists for that email.');
      case 'invalid-email':
        return Exception('The email address is not valid.');
      case 'weak-password':
        return Exception('The password provided is too weak.');
      default:
        return Exception(e.message ?? 'An authentication error occurred.');
    }
  }
}
