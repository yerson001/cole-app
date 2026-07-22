import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF225BAA),
      brightness: Brightness.light,
    ),
    extensions: [AppColors.light],
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF225BAA),
      foregroundColor: Colors.white,
      centerTitle: true,
    ),
    scaffoldBackgroundColor: AppColors.light.background,
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF225BAA),
      brightness: Brightness.dark,
    ),
    extensions: [AppColors.dark],
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: AppColors.dark.surface,
      foregroundColor: AppColors.dark.textPrimary,
    ),
    scaffoldBackgroundColor: AppColors.dark.background,
  );
}
