import 'package:cookit/core/theme/app_spacing.dart';
import 'package:cookit/data/models/recipe_model.dart';
import 'package:cookit/data/services/user_database_service.dart';
import 'package:cookit/features/explore/widgets/explore_recipe_gridcard.dart'; // Reusing the grid card
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoritesProvider = StreamProvider.autoDispose<List<Recipe>>((ref) {
  final dbService = ref.watch(userDatabaseServiceProvider);
  return dbService.getFavoritesStream();
});

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final favoritesAsync = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('My Favourites'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: favoritesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (recipes) {
          if (recipes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bookmark_border,
                      size: 64, color: Colors.grey),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'No favorites yet',
                    style: textTheme.titleMedium?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Save recipes you like to see them here.',
                    style: textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Display in a Grid
          return Padding(
            padding: AppSpacing.pHorizontalLg,
            child: GridView.builder(
              padding: const EdgeInsets.only(top: AppSpacing.md, bottom: 100),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: AppSpacing.sm,
                mainAxisSpacing: AppSpacing.sm,
              ),
              itemCount: recipes.length,
              itemBuilder: (context, i) =>
                  ExploreRecipeGridCard(recipe: recipes[i]),
            ),
          );
        },
      ),
    );
  }
}
