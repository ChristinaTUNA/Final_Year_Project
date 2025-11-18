import 'package:cookit/core/theme/app_borders.dart';
import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../explore_viewmodel.dart';

class ExploreFilterChips extends ConsumerWidget {
  const ExploreFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ⬇️ This is the list of filters you requested
    final filters = [
      'All',
      '5-10 mins',
      'Japanese',
      'Western',
      'Italian',
      'Gluten-Free',
      'Dairy-Free',
      'Vegetarian'
    ];

    final selectedFilter = ref.watch(exploreSelectedFilterProvider);

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = (filter == selectedFilter);

          final color = isSelected ? AppColors.primary : AppColors.primaryLight;
          final textColor = isSelected ? AppColors.white : AppColors.primary;
          final textStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              );

          return GestureDetector(
            onTap: () {
              ref.read(exploreSelectedFilterProvider.notifier).state = filter;
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: color,
                borderRadius: AppBorders.allMd,
              ),
              child: Text(
                filter,
                style: textStyle,
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemCount: filters.length,
      ),
    );
  }
}
