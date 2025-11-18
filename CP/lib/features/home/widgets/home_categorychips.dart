// lib/features/home/widgets/home_categorychips.dart
import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class HomeCategoryChips extends StatelessWidget {
  const HomeCategoryChips({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final items = ['Japanese', 'Mexican', 'Italian', 'Vegan', 'Chinese'];

    final icons = [
      'assets/images/icon_japanese.png',
      'assets/images/icon_mexican.png',
      'assets/images/icon_italian.png',
      'assets/images/icon_vegan.png',
      'assets/images/icon_chinese.png',
    ];

    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        itemBuilder: (context, index) {
          return Column(
            children: [
              // Circular background for icon
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primaryLight,
                child: Image.asset(
                  icons[index],
                  height: 28,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: AppSpacing.sm),
              // Label below icon
              Text(
                items[index],
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
        itemCount: items.length,
      ),
    );
  }
}
