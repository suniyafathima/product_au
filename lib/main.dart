import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:product_au/services/auth_services.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

import 'services/product_service.dart';

import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';

import 'screens/auth/login_screen.dart';
import 'screens/home/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(
            AuthService(),
          ),
        ),

        ChangeNotifierProvider<ProductProvider>(
          create: (_) => ProductProvider(
            ProductService(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Product App',
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        if (auth.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (auth.isAuthenticated) {
          return const HomePage();
        }

        return const LoginScreen();
      },
    );
  }
}