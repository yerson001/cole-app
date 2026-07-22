import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart' as log;
import 'package:coleapp/bloc_provider.dart';
import 'package:coleapp/core/themes/app_theme.dart';
import 'package:coleapp/core/themes/theme_cubit.dart';
import 'package:coleapp/features/auth/presentation/screens/login_page.dart';
import 'package:coleapp/features/roles/presentation/screens/roles_page.dart';
import 'package:coleapp/features/splash/presentation/screens/splash_screen.dart';
import 'package:coleapp/features/director/presentation/screens/director_screen.dart';
import 'package:coleapp/features/promoter/presentation/screens/promoter_screen.dart';
import 'package:coleapp/features/secretary/presentation/screens/secretary_screen.dart';
import 'package:coleapp/features/assistant/presentation/screens/assistant_screen.dart';
import 'package:coleapp/features/teacher/presentation/screens/teacher_screen.dart';
import 'package:coleapp/features/parent/presentation/screens/parent_screen.dart';
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
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
        ...blocProviders,
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Colecheck',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            initialRoute: 'splash',
            routes: {
              'splash': (BuildContext context) => const SplashScreen(),
              'login': (BuildContext context) => const LoginPage(),
              'roles': (BuildContext context) => const RolesPage(),
              'director/home': (BuildContext context) => const DirectorScreen(),
              'promoter/home': (BuildContext context) => const PromoterScreen(),
              'secretary/home': (BuildContext context) => const SecretaryScreen(),
              'assistant/home': (BuildContext context) => const AssistantScreen(),
              'teacher/home': (BuildContext context) => const TeacherScreen(),
              'parent/home': (BuildContext context) => const ParentScreen(),
            },
          );
        },
      ),
    );
  }
}


// #1f1f1f  #24292d
/**
 *  'login': (context) {
          mainLog.info('Ruta: login');
          return const LoginPage();
        },

 */