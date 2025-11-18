import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Holds all base text styles, *without* color.
/// Colors are applied by the [AppTheme] to ensure
/// correct light/dark mode adaptation.
class AppTextStyles {
  AppTextStyles._(); // Private constructor

  /// A new style for large "hero" text.
  static TextStyle get hero => GoogleFonts.poppins(
        fontSize: 68,
        fontWeight: FontWeight.w700,
        height: 1.15,
      );

  // ⬇️ NEW 32px STYLE FOR "Hi, Emily!"
  static TextStyle get headlineLarge => GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get heading1 => GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get heading2 => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get heading3 => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get subtitle => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get body => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get bodyBold => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get caption => GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get button => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get buttonLarge => GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      );
}
