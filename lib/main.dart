import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart' as log;
import 'package:coleapp/bloc_provider.dart';
import 'package:coleapp/features/auth/presentation/screens/login_page.dart';
import 'package:coleapp/features/home/presentation/screens/home_screen.dart';
import 'package:coleapp/features/splash/presentation/screens/splash_screen.dart';
import 'package:coleapp/injection.dart';

final mainLog = log.Logger('MAIN');

void main() async {
  _setupLogging();
  WidgetsFlutterBinding.ensureInitialized();
  mainLog.info('Iniciando app...');
  await configureDependencies();
  mainLog.info('Dependencias registradas en GetIt');
  runApp(const ColecheckApp());
}

void _setupLogging() {
  log.hierarchicalLoggingEnabled = true;

  log.Logger.root.level = log.Level.ALL;
  log.Logger.root.onRecord.listen((record) {
    final msg = '[${record.loggerName}] ${record.level.name}: ${record.message}';
    debugPrintSynchronously(msg);
  });

  debugPrint = (String? message, {int? wrapWidth}) {
    if (message == null) return;
    if (message.startsWith('[')) {
      debugPrintSynchronously(message);
    }
  };
}

class ColecheckApp extends StatelessWidget {
  const ColecheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    mainLog.info('build()');
    return MultiBlocProvider(
      providers: blocProviders,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Colecheck',
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
          'splash': (BuildContext context) => const SplashScreen(),
          'login': (BuildContext context) => const LoginPage(),
          'home': (BuildContext context) => const HomeScreen(),
        },
      ),
    );
  }
}



/**
 *  'login': (context) {
          mainLog.info('Ruta: login');
          return const LoginPage();
        },

 */