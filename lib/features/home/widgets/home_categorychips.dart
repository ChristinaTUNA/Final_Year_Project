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
    final textTheme = Theme.of(context).textTheme;

    // 1. Define the Categories (Icon + Name)
    final categories = [
      {'name': 'Japanese', 'icon': '🍜'},
      {'name': 'Mexican', 'icon': '🌮'},
      {'name': 'Italian', 'icon': '🍕'},
      {'name': 'Vegan', 'icon': '🥗'},
      {'name': 'Chinese', 'icon': '🥡'},
      {'name': 'French', 'icon': '🥐'},
    ];

    void onCategoryTap(String category) {
      ref.read(exploreSearchQueryProvider.notifier).state = '';
      FilterState newFilter;
      if (category == 'Vegan') {
        newFilter = const FilterState(tags: {'Vegan'});
      } else {
        newFilter = FilterState(cuisines: {category});
      }
      ref.read(exploreFilterStateProvider.notifier).state = newFilter;
      ref.read(rootShellProvider.notifier).setIndex(1);
    }

    return SizedBox(
      // 2. Fixed height to prevent layout shifts (Box 70 + Spacing 8 + Text ~20 = ~100)
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final name = cat['name']!;
          final icon = cat['icon']!;

          return GestureDetector(
            onTap: () => onCategoryTap(name),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 3. Icon Container (Rounded Square)
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: AppColors.primary
                        .withValues(alpha: 0.08), // Subtle tint
                    borderRadius: BorderRadius.circular(20), // Soft corners
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => onCategoryTap(name),
                      child: Center(
                        child: Text(
                          icon,
                          style: const TextStyle(fontSize: 30),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // 4. Label (Below the box)
                Text(
                  name,
                  style: textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                    letterSpacing: 0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
