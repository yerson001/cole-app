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
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.light.surface,
      foregroundColor: AppColors.light.textPrimary,
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 1,
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
