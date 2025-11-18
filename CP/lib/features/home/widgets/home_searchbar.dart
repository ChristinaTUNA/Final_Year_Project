import 'package:flutter/material.dart';
import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_decoration.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../root_shell_viewmodel.dart';

class HomeSearchBar extends ConsumerWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 16,
        );
    final bgColor = Theme.of(context).brightness == Brightness.light
        ? AppColors.background
        : AppColors.cardBackgroundDark;

    return GestureDetector(
      onTap: () {
        ref.read(rootShellProvider.notifier).setIndex(1);
      },
      child: Container(
        height: 56,
        decoration: AppDecorations.elevatedCardStyle.copyWith(
          color: bgColor,
        ),
        padding: AppSpacing.pHorizontalMd,
        child: Row(
          children: [
            const Icon(Icons.search, color: AppColors.primary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                'search for food...',
                style: textStyle,
              ),
            ),
            const Icon(Icons.camera_alt_outlined, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
