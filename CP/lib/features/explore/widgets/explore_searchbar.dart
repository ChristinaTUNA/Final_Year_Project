import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_decoration.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../explore_viewmodel.dart';

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

  @override
  Widget build(BuildContext context) {
    final bgColor = Theme.of(context).brightness == Brightness.light
        ? AppColors.background
        : AppColors.cardBackgroundDark;

    return Container(
      height: 56,
      decoration: AppDecorations.elevatedCardStyle.copyWith(
        color: bgColor,
      ),
      padding: AppSpacing.pHorizontalMd,
      child: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(
          icon: Icon(Icons.search, color: AppColors.primary),
          hintText: 'search for food...',
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: (query) {
          ref.read(exploreSearchQueryProvider.notifier).state = query;
        },
      ),
    );
  }
}
