// lib/features/recipe/widgets/recipe_header.dart
import 'package:flutter/material.dart';

class RecipeHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBookmark;

  const RecipeHeader({
    super.key,
    required this.title,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final iconTheme = Theme.of(context).iconTheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: textTheme.displaySmall,
          ),
        ),
        IconButton(
          onPressed: onBookmark,
          icon: Icon(Icons.bookmark_border, color: iconTheme.color),
        ),
      ],
    );
  }
}
