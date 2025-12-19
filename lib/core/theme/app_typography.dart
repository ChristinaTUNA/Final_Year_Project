import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Holds all base text styles, *without* color.
/// Organized following the Material Design 3 type scale.
class AppTextStyles {
  AppTextStyles._(); // Private constructor

  // --- 1. DISPLAY ---
  // Large, high-impact text. Used for "Hero" sections.

  /// 68px, w700
  static TextStyle get displayLarge => GoogleFonts.poppins(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        height: 1.1,
      );

  /// 32px, w700 (Used for "Hi, User!")
  static TextStyle get displayMedium => GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w700,
      );

  /// 28px, w700
  static TextStyle get displaySmall => GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w700,
      );

  // --- 2. HEADLINE ---
  // Primary headers for screens and sections.
  static TextStyle get headlineLarge => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w700,
      );
  static TextStyle get headlineMedium => GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w700,
      );
  static TextStyle get headlineSmall => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w700,
      );

  // --- 3. TITLE ---
  // Medium-emphasis text for list items, cards, and subsections.
  static TextStyle get titleLarge => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      );

  /// 16px, w600 (Was 'subtitle' / 'button')
  static TextStyle get titleMedium => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );

  /// 14px, w600
  static TextStyle get titleSmall => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      );

  // --- 4. BODY ---
  // Long-form text.

  /// 16px, w400 (Readable large body text)
  static TextStyle get bodyLarge => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  /// 14px, w400 (Standard 'body')
  static TextStyle get bodyMedium => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      );

  /// 12px, w400 (Was 'caption')
  static TextStyle get bodySmall => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      );

  // --- 5. LABEL ---
  // Text inside buttons, chips, and small UI elements.

  /// 16px, w600 (Standard Button)
  static TextStyle get labelLarge => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );

  /// 12px, w500 (Small chips)
  static TextStyle get labelMedium => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      );

  /// 10px, w500 (Very small UI elements)
  static TextStyle get labelSmall => GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w500,
      );
}
