import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import 'login_screen.dart';
import '../home/home_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        print('DEBUG: AuthGate - isLoading: ${auth.isLoading}, isAuthenticated: ${auth.isAuthenticated}, user: ${auth.user?.email}');
        
        if (auth.isLoading) {
          print('DEBUG: AuthGate - Showing loading screen');
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (auth.isAuthenticated) {
          print('DEBUG: AuthGate - User authenticated, navigating to HomePage');
          return const HomePage();
        }

        print('DEBUG: AuthGate - User not authenticated, showing LoginScreen');
        return const LoginScreen();
      },
    );
  }
}