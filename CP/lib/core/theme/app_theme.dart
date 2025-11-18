import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_borders.dart';
import 'app_spacing.dart';

/// The central assembly point for the app's theme.
/// This class imports all design system components
/// (Colors, Typography, Borders, Spacing) and maps them
/// to Flutter's [ThemeData] object.
class AppTheme {
  AppTheme._();

  // --- LIGHT THEME ---
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.primaryLight,
      surface: AppColors.white,
      error: Colors.red,
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onSurface: AppColors.textDark,
      onError: AppColors.white,
    ),

    // --- Icon Theme ---
    iconTheme: const IconThemeData(
      color: AppColors.textGray,
      size: 24.0,
    ),

    // --- Text Theme ---
    textTheme: TextTheme(
      headlineLarge: AppTextStyles.hero.copyWith(color: AppColors.textDark),
      displayLarge: AppTextStyles.heading1.copyWith(color: AppColors.textDark),
      displayMedium: AppTextStyles.heading2.copyWith(color: AppColors.textDark),
      displaySmall: AppTextStyles.heading3.copyWith(color: AppColors.textDark),
      titleMedium: AppTextStyles.subtitle.copyWith(color: AppColors.textDark),
      titleSmall: AppTextStyles.bodyBold.copyWith(color: AppColors.textDark),
      bodyLarge: AppTextStyles.body.copyWith(color: AppColors.textDark),
      bodyMedium: AppTextStyles.body.copyWith(color: AppColors.textGray),
      bodySmall: AppTextStyles.caption.copyWith(color: AppColors.textLightGray),
      labelLarge: AppTextStyles.button.copyWith(color: AppColors.white),
    ),

    // --- Component Themes ---
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      elevation: 0,
      titleTextStyle: AppTextStyles.heading2.copyWith(color: AppColors.white),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        textStyle: AppTextStyles.button,
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.lg,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: AppBorders.allMd,
        ),
      ),
    ),

    // --- ENHANCEMENT: Input Decoration Theme ---
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.background,
      hintStyle: AppTextStyles.body.copyWith(color: AppColors.textLightGray),
      contentPadding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.md,
      ),
      border: const OutlineInputBorder(
        borderRadius: AppBorders.allMd,
        borderSide: BorderSide(color: AppColors.divider),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: AppBorders.allMd,
        borderSide: BorderSide(color: AppColors.divider),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: AppBorders.allMd,
        borderSide: BorderSide(color: AppColors.primary, width: 2.0),
      ),
    ),
  );

  // --- DARK THEME ---
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    primaryColor: AppColors.primary,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.cardBackgroundDark,
      error: Colors.red,
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onSurface: AppColors.textDarkTheme,
      onError: AppColors.white,
    ),

    // --- Icon Theme (Dark) ---
    iconTheme: const IconThemeData(
      color: AppColors.textGrayDarkTheme,
      size: 24.0,
    ),

    // --- Text Theme (Dark) ---
    textTheme: TextTheme(
      headlineLarge:
          AppTextStyles.hero.copyWith(color: AppColors.textDarkTheme),
      displayLarge:
          AppTextStyles.heading1.copyWith(color: AppColors.textDarkTheme),
      displayMedium:
          AppTextStyles.heading2.copyWith(color: AppColors.textDarkTheme),
      titleMedium:
          AppTextStyles.subtitle.copyWith(color: AppColors.textDarkTheme),
      bodyLarge: AppTextStyles.body.copyWith(color: AppColors.textDarkTheme),
      bodyMedium:
          AppTextStyles.body.copyWith(color: AppColors.textGrayDarkTheme),
      bodySmall:
          AppTextStyles.caption.copyWith(color: AppColors.textGrayDarkTheme),
      labelLarge: AppTextStyles.button.copyWith(color: AppColors.white),
    ),

    // --- Component Themes (Dark) ---
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      foregroundColor: AppColors.white,
      elevation: 0,
      titleTextStyle: AppTextStyles.heading2.copyWith(color: AppColors.white),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        textStyle: AppTextStyles.button,
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.lg,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: AppBorders.allMd,
        ),
      ),
    ),

    // Input Decoration Theme (Dark) ---
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.cardBackgroundDark,
      hintStyle:
          AppTextStyles.body.copyWith(color: AppColors.textGrayDarkTheme),
      contentPadding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.md,
      ),
      border: const OutlineInputBorder(
        borderRadius: AppBorders.allMd,
        borderSide: BorderSide(color: AppColors.cardBackgroundDark),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: AppBorders.allMd,
        borderSide: BorderSide(color: AppColors.cardBackgroundDark),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: AppBorders.allMd,
        borderSide: BorderSide(color: AppColors.primary, width: 2.0),
      ),
    ),
  );
}
