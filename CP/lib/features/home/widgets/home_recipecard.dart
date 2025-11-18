import 'package:cookit/core/theme/app_spacing.dart';
import 'package:cookit/data/models/recipe_model.dart';
import 'package:flutter/material.dart';

class HomeRecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback? onTap;

  const HomeRecipeCard({
    super.key,
    required this.recipe,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: SizedBox(
          width: 220,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Image Section ---
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  recipe.image,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 150,
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150,
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    );
                  },
                ),
              ),

              // --- Text Section ---
              Padding(
                padding: AppSpacing.pAllMd, // 16px
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      recipe.title,
                      style: textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs), // 4px
                    Text(recipe.subtitle1 ?? '', style: textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
