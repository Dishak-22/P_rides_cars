import 'package:flutter/material.dart';

/// Prime Rides Pune brand palette (light mode only).
class AppColors {
  AppColors._();

  static const royalBlue = Color(0xFF1769C2);
  static const darkBlue = Color(0xFF123A70);
  static const gold = Color(0xFFF2B52B);
  static const goldDark = Color(0xFFB57F00); // gold used for text/icons on white
  static const background = Color(0xFFFFFFFF);
  static const card = Color(0xFFF3F6FA);
  static const textPrimary = Color(0xFF202124);
  static const textSecondary = Color(0xFF626B78);
  static const border = Color(0xFFDCE3EC);
  static const whatsapp = Color(0xFF25D366);
  static const error = Color(0xFFD64545);

  // Legacy names used by the old lib/screens/* files (kept so they still compile).
  static const navy = darkBlue;
  static const navy2 = royalBlue;
  static const teal = royalBlue;
  static const tealDark = darkBlue;
  static const ink = textPrimary;
  static const muted = textSecondary;
  static const bg = background;
  static const line = border;
  static const white = Colors.white;
  static const amber = gold;
  static const red = error;
}

class AppTheme {
  AppTheme._();

  static OutlineInputBorder _border(Color c, [double w = 1]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: c, width: w),
      );

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.royalBlue,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.royalBlue,
      onPrimary: Colors.white,
      secondary: AppColors.gold,
      onSecondary: AppColors.textPrimary,
      surface: AppColors.background,
      onSurface: AppColors.textPrimary,
      outline: AppColors.border,
      error: AppColors.error,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.darkBlue,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(color: AppColors.darkBlue, fontSize: 19, fontWeight: FontWeight.w800),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.card,
      border: _border(AppColors.border),
      enabledBorder: _border(AppColors.border),
      focusedBorder: _border(AppColors.royalBlue, 1.6),
      errorBorder: _border(AppColors.error),
      focusedErrorBorder: _border(AppColors.error, 1.6),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
    ),
    // Gold-filled primary actions (Book Now, Continue, Confirm Booking...).
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.darkBlue,
        minimumSize: const Size.fromHeight(54),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.royalBlue),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.royalBlue,
        side: const BorderSide(color: AppColors.royalBlue),
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.border),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
      titleLarge: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
      bodyLarge: TextStyle(fontSize: 15, color: AppColors.textPrimary),
      bodyMedium: TextStyle(fontSize: 13, color: AppColors.textSecondary),
    ),
  );

  /// Old name, kept for lib/screens/* compatibility.
  static ThemeData get light => lightTheme;
}
