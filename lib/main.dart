import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coleapp/bloc_provider.dart';
import 'package:coleapp/features/auth/presentation/login/screens/login_screen.dart';
import 'package:coleapp/features/splash/presentation/screens/splash_screen.dart';
import 'package:coleapp/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const ColecheckApp());
}

class ColecheckApp extends StatelessWidget {
  const ColecheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: blocProviders,
      child: MaterialApp(
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
        initialRoute: 'splash',
        routes: {
          'splash': (context) => const SplashScreen(),
          'login': (context) => const LoginScreen(),
        },
      ),
    );
  }
}
