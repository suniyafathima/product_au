import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:product_au/services/auth_services.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  AuthProvider(this._authService) {
    _listenToAuthChanges();
  }

  User? _user;

  bool _isLoading = true;

  String? _errorMessage;

  StreamSubscription<User?>? _authSubscription;

  User? get user => _user;

  bool get isLoading => _isLoading;

  bool get isAuthenticated => _user != null;

  String? get errorMessage => _errorMessage;


  void _listenToAuthChanges() {
    _authSubscription = _authService.authStateChanges.listen(
      (User? user) {
        debugPrint(
          '🔥 Firebase Auth State: ${user?.email ?? "SIGNED OUT"}',
        );

        _user = user;
        _isLoading = false;
        _errorMessage = null;

        notifyListeners();
      },
      onError: (Object error) {
        debugPrint(
          '🔥 Firebase Auth State Error: $error',
        );

        _isLoading = false;
        _errorMessage =
            'Unable to check authentication status.';

        notifyListeners();
      },
    );
  }



  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      debugPrint('🔥 Login attempt: ${email.trim()}');

      final credential = await _authService.login(
        email: email.trim(),
        password: password,
      );

      _user = credential.user;

      debugPrint(
        '🔥 Login successful: ${_user?.email}',
      );

      return _user != null;
    } on FirebaseAuthException catch (e) {
      debugPrint(
        '🔥 Firebase Login Error: ${e.code} - ${e.message}',
      );

      _errorMessage = _getErrorMessage(e);

      return false;
    } catch (e) {
      debugPrint(
        '🔥 Login Error: $e',
      );

      _errorMessage =
          'Something went wrong. Please try again.';

      return false;
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }



  Future<bool> register({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      debugPrint(
        '🔥 Registration attempt: ${email.trim()}',
      );

      final credential = await _authService.register(
        email: email.trim(),
        password: password,
      );

      _user = credential.user;

      debugPrint(
        '🔥 Registration successful: ${_user?.email}',
      );

      return _user != null;
    } on FirebaseAuthException catch (e) {
      debugPrint(
        '🔥 Firebase Registration Error: '
        '${e.code} - ${e.message}',
      );

      _errorMessage = _getErrorMessage(e);

      return false;
    } catch (e) {
      debugPrint(
        '🔥 Registration Error: $e',
      );

      _errorMessage =
          'Something went wrong. Please try again.';

      return false;
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }



  Future<bool> logout() async {
    try {
      debugPrint('🔥 Logout started');

      await _authService.logout();

      _user = null;

      debugPrint('🔥 Logout successful');

      notifyListeners();

      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint(
        '🔥 Firebase Logout Error: ${e.code} - ${e.message}',
      );

      _errorMessage =
          'Unable to logout. Please try again.';

      notifyListeners();

      return false;
    } catch (e) {
      debugPrint(
        '🔥 Logout Error: $e',
      );

      _errorMessage =
          'Unable to logout. Please try again.';

      notifyListeners();

      return false;
    }
  }



  String _getErrorMessage(
    FirebaseAuthException e,
  ) {
    debugPrint(
      '🔥 Firebase error code: ${e.code}',
    );

    switch (e.code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Invalid email or password.';

      case 'invalid-email':
        return 'Please enter a valid email address.';

      case 'email-already-in-use':
        return 'An account already exists with this email.';

      case 'weak-password':
        return 'Password is too weak.';

      case 'network-request-failed':
        return 'Please check your internet connection.';

      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';

      case 'user-disabled':
        return 'This account has been disabled.';

      case 'operation-not-allowed':
        return 'Email/password authentication is not enabled in Firebase.';

      default:
        return e.message ??
            'Authentication failed. Please try again.';
    }
  }



  void clearError() {
    _errorMessage = null;

    notifyListeners();
  }



  @override
  void dispose() {
    _authSubscription?.cancel();

    super.dispose();
  }
}
