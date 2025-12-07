import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_decoration.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../explore_viewmodel.dart';
import 'package:cookit/features/explore/widgets/filter_bottomsheet.dart';

class ExploreSearchBar extends ConsumerStatefulWidget {
  const ExploreSearchBar({super.key});

  @override
  ConsumerState<ExploreSearchBar> createState() => _ExploreSearchBarState();
}

class _ExploreSearchBarState extends ConsumerState<ExploreSearchBar> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = ref.read(exploreSearchQueryProvider);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Full height
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = Theme.of(context).brightness == Brightness.light
        ? AppColors.background
        : AppColors.cardBackgroundDark;

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 56,
            decoration: AppDecorations.elevatedCardStyle.copyWith(
              color: bgColor,
            ),
            padding: const EdgeInsets.only(left: AppSpacing.md),
            child: TextField(
              controller: _controller,
              autofocus: false,
              decoration: const InputDecoration(
                icon: Icon(Icons.search, color: AppColors.primary),
                hintText: 'search with ingredients...',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (query) {
                ref.read(exploreSearchQueryProvider.notifier).state = query;
              },
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        // Filter Button
        GestureDetector(
          onTap: _showFilters,
          child: Container(
            height: 56,
            width: 56,
            decoration: AppDecorations.elevatedCardStyle.copyWith(
              color: bgColor,
              borderRadius:
                  BorderRadius.circular(16), // Match search bar radius
            ),
            child: const Icon(Icons.tune, color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}
