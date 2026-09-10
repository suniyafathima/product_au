import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';
import '../home/home_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text(
                'Unable to check authentication status.',
              ),
            ),
          );
        }

        if (snapshot.hasData) {
          return const HomePage();
        }

        return const LoginScreen();
      },
    );
  }
}