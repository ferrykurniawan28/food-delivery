import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: const Color(0xFFE53935),
      scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Color(0xFF323755),
      ),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFE94057),
        secondary: Color(0xFF323755),
      ),
      dividerTheme: DividerThemeData(
        color: Color(0xFFE53935).withOpacity(0.7),
        thickness: 1,
      ),
    );
  }
}
