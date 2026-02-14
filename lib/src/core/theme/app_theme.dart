import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemeColors {
  AppThemeColors._();

  static const Color brand = Color(0xFF661EFB);

  static const Color lightScaffold = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFFAFAFA);
  static const Color lightTextPrimary = Color(0xFF1D1D1F);
  static const Color lightTextSecondary = Color(0xFF767676);
  static const Color lightBorder = Color(0xFFE8E8E8);

  static const Color darkScaffold = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkTextPrimary = Color(0xFFF2F2F2);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkBorder = Color(0xFF2E2E2E);
}

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppThemeColors.brand,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppThemeColors.lightScaffold,
      dividerColor: AppThemeColors.lightBorder,
      textTheme: GoogleFonts.nunitoTextTheme(),
      primaryTextTheme: GoogleFonts.nunitoTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppThemeColors.lightScaffold,
        foregroundColor: AppThemeColors.lightTextPrimary,
        elevation: 0,
      ),
      cardColor: AppThemeColors.lightSurface,
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppThemeColors.brand;
          }
          return Colors.white;
        }),
      ),
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppThemeColors.brand,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppThemeColors.darkScaffold,
      dividerColor: AppThemeColors.darkBorder,
      textTheme: GoogleFonts.nunitoTextTheme(ThemeData.dark().textTheme),
      primaryTextTheme: GoogleFonts.nunitoTextTheme(ThemeData.dark().textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppThemeColors.darkScaffold,
        foregroundColor: AppThemeColors.darkTextPrimary,
        elevation: 0,
      ),
      cardColor: AppThemeColors.darkSurface,
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppThemeColors.brand;
          }
          return AppThemeColors.darkTextSecondary;
        }),
      ),
    );
  }
}
