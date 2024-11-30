import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get the currently signed-in user
  User? get currentUser => _auth.currentUser;

  /// Stream to listen to authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign in with email and password
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error during sign-in: $e');
      throw Exception(_getErrorMessage(e));
    }
  }

  /// Register a new user with email and password
  Future<User?> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error during registration: $e');
      throw Exception(_getErrorMessage(e));
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Error during password reset: $e');
      throw Exception(_getErrorMessage(e));
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error during sign-out: $e');
      throw Exception("Failed to sign out. Please try again.");
    }
  }

  /// Helper function to get readable error messages
  String _getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return "The email address is not valid.";
        case 'user-disabled':
          return "This user has been disabled.";
        case 'user-not-found':
          return "No user found with this email.";
        case 'wrong-password':
          return "The password is incorrect.";
        case 'email-already-in-use':
          return "The email is already registered.";
        case 'weak-password':
          return "The password is too weak.";
        default:
          return error.message ?? "An unknown error occurred.";
      }
    }
    return "An unknown error occurred.";
  }
}
