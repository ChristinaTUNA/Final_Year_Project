import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // Private constructor

  // --- Brand Colors ---
  static const Color primary = Color(0xFFE02200);
  static const Color primaryLight = Color(0xFFFFE6E0);
  //static const Color primaryDark = Color(0xFFB71C1C);
  static const Color white = Colors.white;

  /// A secondary accent color, e.g., for complementary buttons.
  static const Color secondary = Color(0xFFF97316); // Orange accent

  // --- Neutral / Text (Light Mode) ---
  static const Color textDark = Color(0xFF1F2937);
  static const Color textGray = Color(0xFF4B5563);
  static const Color textLightGray = Color(0xFF9CA3AF);

  // --- Backgrounds (Light Mode) ---
  static const Color background = Colors.white;
  static const Color backgroundNeutral = Color(0xFFF3F4F6);
  static const Color cardBackground = Color(0xFFFFF5F3);

  // --- Neutral / Text (Dark Mode) ---
  static const Color textDarkTheme = Colors.white;
  static const Color textGrayDarkTheme =
      Color(0xFF9CA3AF); // Same as light's textLightGray

  // --- Backgrounds (Dark Mode) ---
  static const Color backgroundDark = Color(0xFF111827);
  static const Color cardBackgroundDark = Color(0xFF1F2937);

  // --- Others ---
  static const Color divider = Color(0xFFE5E7EB);
  static const Color shadow = Color(0x1A000000); // 10% opacity black
  static const Color rating = Color(0xFFFFA500); // Orange for ratings
}
