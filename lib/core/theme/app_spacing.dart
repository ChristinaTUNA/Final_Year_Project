// lib/core/theme/app_spacing.dart
import 'package:flutter/material.dart';

/// Holds static constant values for spacing, padding, and gaps.
class AppSpacing {
  AppSpacing._(); // Private constructor

  // --- Base Spacing Values (4-point grid) ---
  /// 4.0
  static const double xs = 4.0;

  /// 8.0
  static const double sm = 8.0;

  /// 16.0
  static const double md = 16.0;

  /// 24.0
  static const double lg = 24.0;

  /// 32.0
  static const double xl = 32.0;

  /// 40.0
  static const double xxl = 40.0;

  // --- Pre-defined EdgeInsets ---
  /// All sides: 8.0
  static const EdgeInsets pAllSm = EdgeInsets.all(sm);

  /// All sides: 16.0
  static const EdgeInsets pAllMd = EdgeInsets.all(md);

  /// All sides: 24.0
  static const EdgeInsets pAllLg = EdgeInsets.all(lg);

  /// All sides: 32.0
  static const EdgeInsets pAllXl = EdgeInsets.all(xl);

  /// Horizontal: 8.0
  static const EdgeInsets pHorizontalSm = EdgeInsets.symmetric(horizontal: sm);

  /// Horizontal: 16.0
  static const EdgeInsets pHorizontalMd = EdgeInsets.symmetric(horizontal: md);

  /// Horizontal: 24.0
  static const EdgeInsets pHorizontalLg = EdgeInsets.symmetric(horizontal: lg);

  /// Vertical: 8.0
  static const EdgeInsets pVerticalSm = EdgeInsets.symmetric(vertical: sm);

  /// Vertical: 16.0
  static const EdgeInsets pVerticalMd = EdgeInsets.symmetric(vertical: md);
}
