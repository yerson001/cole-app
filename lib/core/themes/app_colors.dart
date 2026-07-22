import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  final Color primary;
  final Color primaryDark;
  final Color primaryLight;
  final Color secondary;
  final Color accent;
  final Color accentLight;
  final Color background;
  final Color surface;
  final Color card;
  final Color textPrimary;
  final Color textSecondary;
  final Color textDisabled;
  final Color border;
  final Color divider;
  final Color fill;
  final Color success;
  final Color successLight;
  final Color warning;
  final Color warningLight;
  final Color error;
  final Color errorLight;
  final Color info;
  final Color infoLight;
  final Color buttonPrimary;
  final Color buttonPrimaryText;
  final Color buttonSecondary;
  final Color buttonSecondaryText;
  final Color buttonDisabled;
  final Color buttonDisabledText;
  final Color icon;
  final Color iconActive;
  final Color inputBackground;
  final Color inputBorder;
  final Color inputFocused;
  final Color inputError;
  final Color inputLabel;
  final Color bottomNavBackground;
  final Color bottomNavInactive;
  final Color bottomNavActive;
  final Color overlay;
  final Color shimmer;

  const AppColors({
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.secondary,
    required this.accent,
    required this.accentLight,
    required this.background,
    required this.surface,
    required this.card,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
    required this.border,
    required this.divider,
    required this.fill,
    required this.success,
    required this.successLight,
    required this.warning,
    required this.warningLight,
    required this.error,
    required this.errorLight,
    required this.info,
    required this.infoLight,
    required this.buttonPrimary,
    required this.buttonPrimaryText,
    required this.buttonSecondary,
    required this.buttonSecondaryText,
    required this.buttonDisabled,
    required this.buttonDisabledText,
    required this.icon,
    required this.iconActive,
    required this.inputBackground,
    required this.inputBorder,
    required this.inputFocused,
    required this.inputError,
    required this.inputLabel,
    required this.bottomNavBackground,
    required this.bottomNavInactive,
    required this.bottomNavActive,
    required this.overlay,
    required this.shimmer,
  });

  static const light = AppColors(
    primary: Color(0xFF225BAA),
    primaryDark: Color(0xFF1A237E),
    primaryLight: Color(0xFF64B5F6),
    secondary: Color(0xFFF8F6F0),
    accent: Color(0xFFC8A951),
    accentLight: Color(0xFFE8D5A3),
    background: Color(0xFFFCFCFA),
    surface: Color(0xFFFFFFFF),
    card: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF1A1A2E),
    textSecondary: Color(0xFF6B7280),
    textDisabled: Color(0xFF9CA3AF),
    border: Color(0xFFE5E7EB),
    divider: Color(0xFFF0F0F0),
    fill: Color(0xFFF3F4F6),
    success: Color(0xFF10B981),
    successLight: Color(0xFFD1FAE5),
    warning: Color(0xFFF59E0B),
    warningLight: Color(0xFFFEF3C7),
    error: Color(0xFFEF4444),
    errorLight: Color(0xFFFEE2E2),
    info: Color(0xFF3B82F6),
    infoLight: Color(0xFFDBEAFE),
    buttonPrimary: Color(0xFF225BAA),
    buttonPrimaryText: Color(0xFFFFFFFF),
    buttonSecondary: Color(0xFFF8F6F0),
    buttonSecondaryText: Color(0xFF225BAA),
    buttonDisabled: Color(0xFFD1D5DB),
    buttonDisabledText: Color(0xFF9CA3AF),
    icon: Color(0xFF6B7280),
    iconActive: Color(0xFF225BAA),
    inputBackground: Color(0xFFF9FAFB),
    inputBorder: Color(0xFFD1D5DB),
    inputFocused: Color(0xFF225BAA),
    inputError: Color(0xFFEF4444),
    inputLabel: Color(0xFF6B7280),
    bottomNavBackground: Color(0xFFFFFFFF),
    bottomNavInactive: Color(0xFF9CA3AF),
    bottomNavActive: Color(0xFF225BAA),
    overlay: Color(0x80000000),
    shimmer: Color(0xFFE5E7EB),
  );

  static const dark = AppColors(
    primary: Color(0xFF64B5F6),
    primaryDark: Color(0xFF225BAA),
    primaryLight: Color(0xFF90CAF9),
    secondary: Color(0xFF24292D),
    accent: Color(0xFFFFD54F),
    accentLight: Color(0xFFFFF8E1),
    background: Color(0xFF1F1F1F),
    surface: Color(0xFF24292D),
    card: Color(0xFF24292D),
    textPrimary: Color(0xFFE8E8E8),
    textSecondary: Color(0xFF9E9E9E),
    textDisabled: Color(0xFF616161),
    border: Color(0xFF363837),
    divider: Color(0xFF363837),
    fill: Color(0xFF24292D),
    success: Color(0xFF4CAF50),
    successLight: Color(0xFF1B5E20),
    warning: Color(0xFFFFA726),
    warningLight: Color(0xFFE65100),
    error: Color(0xFFEF5350),
    errorLight: Color(0xFFB71C1C),
    info: Color(0xFF42A5F5),
    infoLight: Color(0xFF0D47A1),
    buttonPrimary: Color(0xFF64B5F6),
    buttonPrimaryText: Color(0xFF121212),
    buttonSecondary: Color(0xFF24292D),
    buttonSecondaryText: Color(0xFFE8E8E8),
    buttonDisabled: Color(0xFF2C2C2C),
    buttonDisabledText: Color(0xFF616161),
    icon: Color(0xFF9E9E9E),
    iconActive: Color(0xFF64B5F6),
    inputBackground: Color(0xFF24292D),
    inputBorder: Color(0xFF363837),
    inputFocused: Color(0xFF64B5F6),
    inputError: Color(0xFFEF5350),
    inputLabel: Color(0xFF9E9E9E),
    bottomNavBackground: Color(0xFF24292D),
    bottomNavInactive: Color(0xFF616161),
    bottomNavActive: Color(0xFF64B5F6),
    overlay: Color(0xB3000000),
    shimmer: Color(0xFF363837),
  );

  @override
  AppColors copyWith({
    Color? primary,
    Color? primaryDark,
    Color? primaryLight,
    Color? secondary,
    Color? accent,
    Color? accentLight,
    Color? background,
    Color? surface,
    Color? card,
    Color? textPrimary,
    Color? textSecondary,
    Color? textDisabled,
    Color? border,
    Color? divider,
    Color? fill,
    Color? success,
    Color? successLight,
    Color? warning,
    Color? warningLight,
    Color? error,
    Color? errorLight,
    Color? info,
    Color? infoLight,
    Color? buttonPrimary,
    Color? buttonPrimaryText,
    Color? buttonSecondary,
    Color? buttonSecondaryText,
    Color? buttonDisabled,
    Color? buttonDisabledText,
    Color? icon,
    Color? iconActive,
    Color? inputBackground,
    Color? inputBorder,
    Color? inputFocused,
    Color? inputError,
    Color? inputLabel,
    Color? bottomNavBackground,
    Color? bottomNavInactive,
    Color? bottomNavActive,
    Color? overlay,
    Color? shimmer,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      primaryDark: primaryDark ?? this.primaryDark,
      primaryLight: primaryLight ?? this.primaryLight,
      secondary: secondary ?? this.secondary,
      accent: accent ?? this.accent,
      accentLight: accentLight ?? this.accentLight,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      card: card ?? this.card,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textDisabled: textDisabled ?? this.textDisabled,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      fill: fill ?? this.fill,
      success: success ?? this.success,
      successLight: successLight ?? this.successLight,
      warning: warning ?? this.warning,
      warningLight: warningLight ?? this.warningLight,
      error: error ?? this.error,
      errorLight: errorLight ?? this.errorLight,
      info: info ?? this.info,
      infoLight: infoLight ?? this.infoLight,
      buttonPrimary: buttonPrimary ?? this.buttonPrimary,
      buttonPrimaryText: buttonPrimaryText ?? this.buttonPrimaryText,
      buttonSecondary: buttonSecondary ?? this.buttonSecondary,
      buttonSecondaryText: buttonSecondaryText ?? this.buttonSecondaryText,
      buttonDisabled: buttonDisabled ?? this.buttonDisabled,
      buttonDisabledText: buttonDisabledText ?? this.buttonDisabledText,
      icon: icon ?? this.icon,
      iconActive: iconActive ?? this.iconActive,
      inputBackground: inputBackground ?? this.inputBackground,
      inputBorder: inputBorder ?? this.inputBorder,
      inputFocused: inputFocused ?? this.inputFocused,
      inputError: inputError ?? this.inputError,
      inputLabel: inputLabel ?? this.inputLabel,
      bottomNavBackground: bottomNavBackground ?? this.bottomNavBackground,
      bottomNavInactive: bottomNavInactive ?? this.bottomNavInactive,
      bottomNavActive: bottomNavActive ?? this.bottomNavActive,
      overlay: overlay ?? this.overlay,
      shimmer: shimmer ?? this.shimmer,
    );
  }

  @override
  AppColors lerp(covariant AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentLight: Color.lerp(accentLight, other.accentLight, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      card: Color.lerp(card, other.card, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      border: Color.lerp(border, other.border, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      fill: Color.lerp(fill, other.fill, t)!,
      success: Color.lerp(success, other.success, t)!,
      successLight: Color.lerp(successLight, other.successLight, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningLight: Color.lerp(warningLight, other.warningLight, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorLight: Color.lerp(errorLight, other.errorLight, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoLight: Color.lerp(infoLight, other.infoLight, t)!,
      buttonPrimary: Color.lerp(buttonPrimary, other.buttonPrimary, t)!,
      buttonPrimaryText: Color.lerp(buttonPrimaryText, other.buttonPrimaryText, t)!,
      buttonSecondary: Color.lerp(buttonSecondary, other.buttonSecondary, t)!,
      buttonSecondaryText: Color.lerp(buttonSecondaryText, other.buttonSecondaryText, t)!,
      buttonDisabled: Color.lerp(buttonDisabled, other.buttonDisabled, t)!,
      buttonDisabledText: Color.lerp(buttonDisabledText, other.buttonDisabledText, t)!,
      icon: Color.lerp(icon, other.icon, t)!,
      iconActive: Color.lerp(iconActive, other.iconActive, t)!,
      inputBackground: Color.lerp(inputBackground, other.inputBackground, t)!,
      inputBorder: Color.lerp(inputBorder, other.inputBorder, t)!,
      inputFocused: Color.lerp(inputFocused, other.inputFocused, t)!,
      inputError: Color.lerp(inputError, other.inputError, t)!,
      inputLabel: Color.lerp(inputLabel, other.inputLabel, t)!,
      bottomNavBackground: Color.lerp(bottomNavBackground, other.bottomNavBackground, t)!,
      bottomNavInactive: Color.lerp(bottomNavInactive, other.bottomNavInactive, t)!,
      bottomNavActive: Color.lerp(bottomNavActive, other.bottomNavActive, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
      shimmer: Color.lerp(shimmer, other.shimmer, t)!,
    );
  }
}

extension AppColorsX on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}
