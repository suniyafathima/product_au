import 'package:firebase_auth/firebase_auth.dart';

class AuthErrorHandler {
  static String getMessage(FirebaseAuthException e) {
    switch (e.code) {
      // Registration
      case 'email-already-in-use':
        return 'An account already exists with this email address.';

      case 'invalid-email':
        return 'Please enter a valid email address.';

      case 'weak-password':
        return 'Password is too weak. Please use a stronger password.';

      // Login
      case 'invalid-credential':
        return 'Invalid email or password.';

      case 'user-not-found':
        return 'No account was found with this email address.';

      case 'wrong-password':
        return 'Incorrect password.';

      // Network
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';

      // Other
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';

      case 'user-disabled':
        return 'This account has been disabled.';

      case 'operation-not-allowed':
        return 'Email/password authentication is not enabled.';

      default:
        return 'Something went wrong. Please try again.';
    }
  }
}