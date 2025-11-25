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
      // 1. DISPLAY (Hero / Huge text)
      displayLarge: AppTextStyles.displayLarge
          .copyWith(color: AppColors.textDark), // 56px
      displayMedium: AppTextStyles.displayMedium
          .copyWith(color: AppColors.textDark), // 32px
      displaySmall: AppTextStyles.displaySmall
          .copyWith(color: AppColors.textDark), // 28px

      // 2. HEADLINE (Screen titles)
      headlineLarge: AppTextStyles.headlineLarge
          .copyWith(color: AppColors.textDark), // 24px
      headlineMedium: AppTextStyles.headlineMedium
          .copyWith(color: AppColors.textDark), // 22px
      headlineSmall: AppTextStyles.headlineSmall
          .copyWith(color: AppColors.textDark), // 20px

      // 3. TITLE (Card titles, Section headers)
      titleLarge:
          AppTextStyles.titleLarge.copyWith(color: AppColors.textDark), // 18px
      titleMedium:
          AppTextStyles.titleMedium.copyWith(color: AppColors.textDark), // 16px
      titleSmall:
          AppTextStyles.titleSmall.copyWith(color: AppColors.textDark), // 14px

      // 4. BODY (Paragraphs, Lists)
      bodyLarge:
          AppTextStyles.bodyLarge.copyWith(color: AppColors.textDark), // 16px
      bodyMedium:
          AppTextStyles.bodyMedium.copyWith(color: AppColors.textGray), // 14px
      bodySmall: AppTextStyles.bodySmall
          .copyWith(color: AppColors.textLightGray), // 12px

      // 5. LABEL (Buttons, Chips)
      labelLarge:
          AppTextStyles.labelLarge.copyWith(color: AppColors.white), // 16px
      labelMedium:
          AppTextStyles.labelMedium.copyWith(color: AppColors.textGray), // 12px
    ),

    // --- Component Themes ---
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textDark,
      elevation: 0,
      // Uses Headline Large (24px) for App Bar titles
      titleTextStyle:
          AppTextStyles.headlineLarge.copyWith(color: AppColors.textDark),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        // Uses Label Large (16px w600) for buttons
        textStyle: AppTextStyles.labelLarge,
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.lg,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: AppBorders.allMd,
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.background,
      hintStyle:
          AppTextStyles.bodyMedium.copyWith(color: AppColors.textLightGray),
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

    iconTheme: const IconThemeData(
      color: AppColors.textGrayDarkTheme,
      size: 24.0,
    ),

    // --- Text Theme (Dark Mode Mapping) ---
    textTheme: TextTheme(
      // Display
      displayLarge:
          AppTextStyles.displayLarge.copyWith(color: AppColors.textDarkTheme),
      displayMedium:
          AppTextStyles.displayMedium.copyWith(color: AppColors.textDarkTheme),
      displaySmall:
          AppTextStyles.displaySmall.copyWith(color: AppColors.textDarkTheme),

      // Headline
      headlineLarge:
          AppTextStyles.headlineLarge.copyWith(color: AppColors.textDarkTheme),
      headlineMedium:
          AppTextStyles.headlineMedium.copyWith(color: AppColors.textDarkTheme),
      headlineSmall:
          AppTextStyles.headlineSmall.copyWith(color: AppColors.textDarkTheme),

      // Title
      titleLarge:
          AppTextStyles.titleLarge.copyWith(color: AppColors.textDarkTheme),
      titleMedium:
          AppTextStyles.titleMedium.copyWith(color: AppColors.textDarkTheme),
      titleSmall:
          AppTextStyles.titleSmall.copyWith(color: AppColors.textDarkTheme),

      // Body
      bodyLarge:
          AppTextStyles.bodyLarge.copyWith(color: AppColors.textDarkTheme),
      bodyMedium:
          AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrayDarkTheme),
      bodySmall:
          AppTextStyles.bodySmall.copyWith(color: AppColors.textGrayDarkTheme),

      // Label
      labelLarge: AppTextStyles.labelLarge.copyWith(color: AppColors.white),
      labelMedium: AppTextStyles.labelMedium
          .copyWith(color: AppColors.textGrayDarkTheme),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      foregroundColor: AppColors.textDarkTheme,
      elevation: 0,
      titleTextStyle:
          AppTextStyles.headlineLarge.copyWith(color: AppColors.textDarkTheme),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        textStyle: AppTextStyles.labelLarge,
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.lg,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: AppBorders.allMd,
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.cardBackgroundDark,
      hintStyle:
          AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrayDarkTheme),
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
