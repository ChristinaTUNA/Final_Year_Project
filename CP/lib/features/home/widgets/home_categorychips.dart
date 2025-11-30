// lib/features/home/widgets/home_categorychips.dart
import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:cookit/data/models/filter_state.dart';
import 'package:cookit/features/explore/explore_viewmodel.dart';
import 'package:cookit/features/shared/root_shell_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeCategoryChips extends ConsumerWidget {
  const HomeCategoryChips({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Define the Categories (Icon + Name)
    final categories = [
      {'name': 'Japanese', 'icon': '🍜'},
      {'name': 'Mexican', 'icon': '🌮'},
      {'name': 'Italian', 'icon': '🍕'},
      {'name': 'Vegan', 'icon': '🥗'},
      {'name': 'Chinese', 'icon': '🥡'},
    ];

    void onCategoryTap(String category) {
      // Step A: Clear any existing search text to avoid conflicts
      ref.read(exploreSearchQueryProvider.notifier).state = '';

      // Step B: Construct the specific filter
      FilterState newFilter;

      if (category == 'Vegan') {
        // 'Vegan' is a Diet/Tag, not a Cuisine
        newFilter = const FilterState(tags: {'Vegan'});
      } else {
        // The rest are Cuisines
        newFilter = FilterState(cuisines: {category});
      }

      // Step C: Update the Explore Provider
      // This triggers the API call immediately in the background
      ref.read(exploreFilterStateProvider.notifier).state = newFilter;

      // Step D: Navigate to Explore Tab (Index 1)
      ref.read(rootShellProvider.notifier).setIndex(1);
    }

    return SizedBox(
      height: 100, // Fixed height for the row
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) {
          final cat = categories[index];

          return GestureDetector(
            onTap: () => onCategoryTap(cat['name']!),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // The Rounded Square Box
                Container(
                  width: 90,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16), // Rounded Corners
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(cat['icon']!,
                            style: const TextStyle(fontSize: 32)),
                        const SizedBox(height: 5),
                        Text(
                          cat['name']!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
