import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:cookit/features/explore/explore_viewmodel.dart';
import 'package:cookit/features/shared/root_shell_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'scan_viewmodel.dart';
import 'package:cookit/data/models/scanned_ingredient.dart';
import 'widgets/scan_result_card.dart';
import 'package:cookit/features/scan/widgets/scan_camera_view.dart';
import 'package:cookit/data/services/user_database_service.dart';
import 'package:cookit/data/models/list_item.dart';

class ScanScreen extends ConsumerWidget {
  const ScanScreen({super.key});

  Future<void> _pickFromGallery(WidgetRef ref) async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      ref.read(scanViewModelProvider.notifier).analyzeImage(imageFile);
    }
  }

  void _onPictureTaken(WidgetRef ref, XFile file) {
    ref.read(scanViewModelProvider.notifier).analyzeImage(file);
  }

  // ⬇️ IMPLEMENTED: Add to Pantry Logic
  Future<void> _addToPantry(BuildContext context, WidgetRef ref,
      List<ScannedIngredient> results) async {
    try {
      // 1. Convert ScannedIngredient -> ListItem
      final pantryItems = results
          .map((scanned) => ListItem(
                name: scanned.name,
                category: scanned.category,
                // You can set a default quantity if you like, e.g., "1"
                quantity: "1",
              ))
          .toList();

      // 2. Save to Firestore via Service
      await ref
          .read(userDatabaseServiceProvider)
          .addItems(pantryItems, 'pantry');

      // 3. Show Success Feedback
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added ${results.length} items to your Pantry!'),
            backgroundColor: AppColors.primary,
          ),
        );

        // Optional: Clear the scan results after adding
        ref.read(scanViewModelProvider.notifier).clearScan();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding items: $e')),
        );
      }
    }
  }

  void _findRecipes(
      BuildContext context, WidgetRef ref, List<String> ingredients) {
    final query = ingredients.join(',');
    ref.read(exploreSearchQueryProvider.notifier).state = query;
    ref.read(rootShellProvider.notifier).setIndex(1);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final scanState = ref.watch(scanViewModelProvider);

    if (scanState.value == null &&
        !scanState.isLoading &&
        !scanState.hasError) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            ScanCameraView(
              onPictureTaken: (file) => _onPictureTaken(ref, file),
              onGalleryPressed: () => _pickFromGallery(ref),
            ),
            Positioned(
              top: 50,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Scan Results', style: textTheme.headlineSmall),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (scanState.value != null) {
              ref.read(scanViewModelProvider.notifier).clearScan();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: scanState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: ${err.toString()}')),
        data: (results) {
          if (results == null) return const SizedBox.shrink();

          if (results.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No ingredients found.'),
                  TextButton(
                    onPressed: () =>
                        ref.read(scanViewModelProvider.notifier).clearScan(),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }
          return _buildResultsView(context, ref, results);
        },
      ),
    );
  }

  Widget _buildResultsView(
      BuildContext context, WidgetRef ref, List<ScannedIngredient> results) {
    final ingredientNames = results.map((e) => e.name).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppSpacing.pHorizontalLg,
          child: Text(
            'Ingredients found (${results.length})',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: GridView.builder(
            padding: AppSpacing.pHorizontalLg.copyWith(bottom: 100),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.8,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
            ),
            itemCount: results.length,
            itemBuilder: (context, index) {
              return ScanResultCard(ingredient: results[index]);
            },
          ),
        ),
        Container(
          padding: AppSpacing.pAllLg,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppColors.divider)),
          ),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: OutlinedButton(
                    // ⬇️ CONNECTED: Call the new _addToPantry function
                    onPressed: () => _addToPantry(context, ref, results),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      foregroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Add to Pantry'),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () =>
                        _findRecipes(context, ref, ingredientNames),
                    child: const Text('Find Recipes'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
