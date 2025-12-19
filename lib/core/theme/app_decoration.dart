// lib/core/theme/app_decoration.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_borders.dart';

class AppDecorations {
  AppDecorations._();

  static BoxDecoration get card => const BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppBorders.allLg,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      );

  static BoxDecoration get elevated => const BoxDecoration(
        color: AppColors.background,
        borderRadius: AppBorders.allMd,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 6),
          ),
        ],
      );

  static BoxDecoration get elevatedCardStyle => const BoxDecoration(
        borderRadius: AppBorders.allLg, // 16px
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      );
}
