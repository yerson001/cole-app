import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF003366),
      brightness: Brightness.light,
    ),
    extensions: [AppColors.light],
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF003366),
      foregroundColor: Colors.white,
      centerTitle: true,
    ),
    scaffoldBackgroundColor: AppColors.light.background,
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF003366),
      brightness: Brightness.dark,
    ),
    extensions: [AppColors.dark],
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: Color(0xFF24292D),
      foregroundColor: Color(0xFFE8E8E8),
    ),
    scaffoldBackgroundColor: Color(0xFF1F1F1F),
  );
}
