import 'package:flutter/material.dart';
import 'package:coleapp/features/splash/presentation/screens/splash_screen.dart';

void main() {
  runApp(const ColecheckApp());
}

class ColecheckApp extends StatelessWidget {
  const ColecheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Colecheck',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF003366),
          primary: const Color(0xFF003366),
          secondary: const Color(0xFF4CAF50),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
