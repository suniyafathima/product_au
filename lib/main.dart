import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:product_au/services/auth_services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

import 'services/product_service.dart';
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'screens/auth/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final SharedPreferences prefs =
      await SharedPreferences.getInstance();

  runApp(
    MyApp(
      prefs: prefs,
    ),
  );
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({
    super.key,
    required this.prefs,
  });

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
            prefs,
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Product App',
        home: const AuthGate(),
      ),
    );
  }
}