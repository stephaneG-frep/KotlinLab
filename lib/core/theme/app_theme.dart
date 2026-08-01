import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppColors {
  static const primary = Color(0xFF7F52FF);
  static const primaryDark = Color(0xFF5D35D5);
  static const secondary = Color(0xFF4CC2FF);
  static const accent = Color(0xFFFFC857);
  static const success = Color(0xFF4CAF50);
  static const error = Color(0xFFE53935);
  static const lightBackground = Color(0xFFF6F7FB);
  static const darkBackground = Color(0xFF121212);
  static const ink = Color(0xFF17152A);
  static const muted = Color(0xFF77748A);
}

abstract final class AppTheme {
  static ThemeData light(double scale) => _theme(Brightness.light, scale);
  static ThemeData dark(double scale) => _theme(Brightness.dark, scale);

  static ThemeData _theme(Brightness brightness, double scale) {
    final dark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: dark ? const Color(0xFF1D1C24) : Colors.white,
      error: AppColors.error,
    );
    final baseText = GoogleFonts.plusJakartaSansTextTheme(
      dark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: dark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      textTheme: baseText
          .copyWith(
            displaySmall: baseText.displaySmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -1.2,
              height: 1.05,
            ),
            headlineMedium: baseText.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
            titleLarge: baseText.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
            titleMedium: baseText.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            labelLarge: baseText.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          )
          .apply(fontSizeFactor: scale),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surface,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: dark ? const Color(0xFF25242C) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        elevation: 0,
        backgroundColor: dark ? const Color(0xFF1B1A21) : Colors.white,
        indicatorColor: AppColors.primary.withValues(alpha: .14),
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
