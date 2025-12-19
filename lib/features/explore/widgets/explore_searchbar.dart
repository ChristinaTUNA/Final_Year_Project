import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_decoration.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:cookit/features/explore/explore_viewmodel.dart';
import 'package:cookit/features/explore/widgets/filter_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExploreSearchBar extends ConsumerStatefulWidget {
  const ExploreSearchBar({super.key});

  @override
  ConsumerState<ExploreSearchBar> createState() => _ExploreSearchBarState();
}

class _ExploreSearchBarState extends ConsumerState<ExploreSearchBar> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Initialize text with current state
    _controller.text = ref.read(exploreSearchQueryProvider);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterBottomSheet(),
    );
  }

  void _onClear() {
    _controller.clear();
    ref.read(exploreSearchQueryProvider.notifier).state = '';
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    // 1. SYNC: Listen to external changes (e.g. Home Category Chips)
    ref.listen(exploreSearchQueryProvider, (prev, next) {
      if (_controller.text != next) {
        _controller.text = next;
        // Move cursor to end of text
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
      }
    });

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor =
        isDark ? AppColors.cardBackgroundDark : AppColors.background;

    // Shared decoration for consistency
    final boxDecoration = AppDecorations.elevatedCardStyle.copyWith(
      color: bgColor,
      borderRadius: BorderRadius.circular(16),
    );

    return Row(
      children: [
        // --- Search Text Field ---
        Expanded(
          child: Container(
            height: 56,
            decoration: boxDecoration,
            padding: const EdgeInsets.only(left: AppSpacing.sm),
            alignment: Alignment.center,
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              textAlignVertical: TextAlignVertical.center,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Search ingredients or recipes...',
                hintStyle:
                    theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                // 2. Clear Button (Only shows when not empty)
                suffixIcon: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _controller,
                  builder: (context, value, child) {
                    if (value.text.isEmpty) return const SizedBox.shrink();
                    return IconButton(
                      icon:
                          const Icon(Icons.clear, color: Colors.grey, size: 20),
                      onPressed: _onClear,
                    );
                  },
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onSubmitted: (query) {
                ref.read(exploreSearchQueryProvider.notifier).state = query;
              },
            ),
          ),
        ),

        const SizedBox(width: AppSpacing.sm),

        // --- Filter Button ---
        Container(
          height: 56,
          width: 56,
          decoration: boxDecoration,
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: _showFilters,
              child: const Center(
                child: Icon(Icons.tune_rounded, color: AppColors.primary),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
