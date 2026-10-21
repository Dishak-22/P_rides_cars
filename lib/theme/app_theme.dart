import 'package:flutter/material.dart';

class AppColors {
  static const navy = Color(0xFF081B33);
  static const navy2 = Color(0xFF102B4D);
  static const teal = Color(0xFF13C8B2);
  static const tealDark = Color(0xFF0AA694);
  static const ink = Color(0xFF142236);
  static const muted = Color(0xFF6B7788);
  static const bg = Color(0xFFF5F7FA);
  static const line = Color(0xFFE4E9EF);
  static const white = Colors.white;
  static const amber = Color(0xFFFFB020);
  static const red = Color(0xFFE45454);
}

class AppTheme {
  static ThemeData light = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.teal, brightness: Brightness.light).copyWith(primary: AppColors.teal, onPrimary: AppColors.navy),
    fontFamily: 'sans',
    appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent, foregroundColor: AppColors.ink, elevation: 0, centerTitle: false),
    inputDecorationTheme: InputDecorationTheme(
      filled: true, fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.line)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.line)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.teal, width: 1.5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: AppColors.ink),
      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.ink),
      titleLarge: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.ink),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.ink),
      bodyLarge: TextStyle(fontSize: 15, color: AppColors.ink),
      bodyMedium: TextStyle(fontSize: 13, color: AppColors.muted),
    ),
  );
}
