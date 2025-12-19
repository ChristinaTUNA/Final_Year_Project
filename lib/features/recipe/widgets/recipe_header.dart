import 'package:cookit/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class RecipeHeader extends StatelessWidget {
  final String title;
  final bool isFavorite;
  final VoidCallback onToggle;

  const RecipeHeader({
    super.key,
    required this.title,
    required this.isFavorite,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(4, -6),
          child: IconButton(
            onPressed: onToggle,
            tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Icon(
                isFavorite ? Icons.bookmark : Icons.bookmark_border,
                key: ValueKey(isFavorite),
                color: isFavorite ? AppColors.primary : AppColors.textGray,
                size: 30,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
