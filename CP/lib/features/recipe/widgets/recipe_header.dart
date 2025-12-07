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
            style: textTheme.displaySmall,
          ),
        ),
        Transform.translate(
          offset: const Offset(4, -6),
          child: IconButton(
            onPressed: onToggle,
            icon: Icon(
              isFavorite ? Icons.bookmark : Icons.bookmark_border,
              color: isFavorite ? AppColors.primary : AppColors.textGray,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }
}
