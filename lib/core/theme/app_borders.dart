import 'package:flutter/material.dart';

/// Holds static constant values for border radii.
class AppBorders {
  AppBorders._(); // Private constructor

  // --- Base Radius Values ---
  /// 8.0
  static const double radiusSm = 8.0;

  /// 12.0
  static const double radiusMd = 12.0;

  /// 16.0
  static const double radiusLg = 16.0;

  /// 24.0
  static const double radiusXl = 24.0;

  /// 32.0
  static const double radiusXxl = 32.0;

  // --- Pre-defined BorderRadius Objects ---

  /// BorderRadius.vertical(top: Radius.circular(24.0))
  static const BorderRadius pVerticleTopLg =
      BorderRadius.vertical(top: Radius.circular(radiusXl));

  /// BorderRadius.all(4.0)
  static const BorderRadius allXs = BorderRadius.all(Radius.circular(4.0));

  /// BorderRadius.all(8.0)
  static const BorderRadius allSm = BorderRadius.all(Radius.circular(radiusSm));

  /// BorderRadius.all(12.0)
  static const BorderRadius allMd = BorderRadius.all(Radius.circular(radiusMd));

  /// BorderRadius.all(16.0)
  static const BorderRadius allLg = BorderRadius.all(Radius.circular(radiusLg));

  /// BorderRadius.all(24.0)
  static const BorderRadius allXl = BorderRadius.all(Radius.circular(radiusXl));

  /// BorderRadius.all(32.0)
  static const BorderRadius allXxl =
      BorderRadius.all(Radius.circular(radiusXxl));

  /// pill border radius
  static const BorderRadius pill = BorderRadius.all(Radius.circular(50.0));
}
