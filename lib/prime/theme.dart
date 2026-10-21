import 'package:flutter/material.dart';

class P {
  static const navy = Color(0xFF10233F);
  static const blue = Color(0xFF2457E6);
  static const pale = Color(0xFFF4F7FC);
  static const muted = Color(0xFF69778C);
  static const line = Color(0xFFE2E8F2);
  static const green = Color(0xFF20C66B);
  static const red = Color(0xFFE45454);
}

ThemeData primeTheme() {
  OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: c, width: w));
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: P.pale,
    colorScheme: ColorScheme.fromSeed(seedColor: P.blue).copyWith(primary: P.blue),
    appBarTheme: const AppBarTheme(
      backgroundColor: P.pale,
      foregroundColor: P.navy,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(color: P.navy, fontSize: 19, fontWeight: FontWeight.w800),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: border(P.line),
      enabledBorder: border(P.line),
      focusedBorder: border(P.blue, 1.6),
      errorBorder: border(P.red),
      focusedErrorBorder: border(P.red, 1.6),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: P.blue,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(54),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
      ),
    ),
  );
}
