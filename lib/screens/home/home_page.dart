import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logged out successfully'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message ?? 'Unable to logout. Please try again.',
          ),
        ),
      );
    } catch (_) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Something went wrong. Please try again.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Welcome!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}