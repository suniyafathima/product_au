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
    _authSubscription =
        _authService.authStateChanges.listen(
      (User? user) {
        _user = user;
        _isLoading = false;

        notifyListeners();
      },
      onError: (_) {
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
      await _authService.login(
        email: email,
        password: password,
      );

      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getErrorMessage(e);
      return false;
    } catch (_) {
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
      await _authService.register(
        email: email,
        password: password,
      );

      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getErrorMessage(e);
      return false;
    } catch (_) {
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
      await _authService.logout();
      return true;
    } catch (_) {
      _errorMessage =
          'Unable to logout. Please try again.';

      notifyListeners();

      return false;
    }
  }

  String _getErrorMessage(
    FirebaseAuthException e,
  ) {
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
        return 'Email/password authentication is not enabled.';

      default:
        return 'Authentication failed. Please try again.';
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