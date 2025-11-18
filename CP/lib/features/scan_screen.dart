import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:cookit/data/models/scanned_ingredient_model.dart';
import 'package:cookit/features/explore/explore_viewmodel.dart';
import 'package:cookit/features/root_shell_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'scan_viewmodel.dart';

class ScanScreen extends ConsumerWidget {
  const ScanScreen({super.key});

  /// Opens the camera or gallery
  Future<void> _pickImage(WidgetRef ref, ImageSource source) async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(source: source, imageQuality: 50);

    if (imageFile != null) {
      ref.read(scanViewModelProvider.notifier).analyzeImage(imageFile);
    }
  }

  /// Takes the results and triggers the search
  void _findRecipes(
      BuildContext context, WidgetRef ref, List<String> ingredients) {
    // 1. Join all ingredient names into a single search query
    final query = ingredients.join(',');

    // 2. Set the search query in the Explore provider
    ref.read(exploreSearchQueryProvider.notifier).state = query;

    // 3. Set the active tab to the Explore screen (index 1)
    ref.read(rootShellProvider.notifier).setIndex(1);

    // 4. Close the scan screen
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final scanState = ref.watch(scanViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Ingredients', style: textTheme.headlineSmall),
        actions: [
          // Add a "Clear" button to start over
          if (scanState.value != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () =>
                  ref.read(scanViewModelProvider.notifier).clearScan(),
            )
        ],
      ),
      body: Padding(
        padding: AppSpacing.pHorizontalLg,
        child: Column(
          children: [
            // ⬇️ This is the main body, which changes
            Expanded(
              child: scanState.when(
                // --- LOADING STATE ---
                loading: () => const Center(child: CircularProgressIndicator()),

                // --- ERROR STATE ---
                error: (err, stack) => Center(
                  child: Text('Error: ${err.toString()}'),
                ),

                // --- DATA STATE ---
                data: (results) {
                  // results == null means we are on the initial "pick an image" screen
                  if (results == null) {
                    return _buildImagePicker(context, ref);
                  }

                  // results.isEmpty means Gemini found nothing
                  if (results.isEmpty) {
                    return const Center(
                      child: Text('No ingredients found. Try another photo!'),
                    );
                  }

                  // SUCCESS: Show the results list
                  return _buildResultsList(context, ref, results);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// The "Pick an Image" view (initial state)
  Widget _buildImagePicker(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.photo_camera_outlined, size: 80),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Scan your pantry or fridge',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () => _pickImage(ref, ImageSource.camera),
            icon: const Icon(Icons.camera_alt),
            label: const Text('Open Camera'),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () => _pickImage(ref, ImageSource.gallery),
            icon: const Icon(Icons.photo_library),
            label: const Text('Open Gallery'),
          ),
        ),
      ],
    );
  }

  /// The "Results" view (after scan is complete)
  Widget _buildResultsList(
      BuildContext context, WidgetRef ref, List<ScannedIngredient> results) {
    final ingredientNames = results.map((e) => e.name).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Found ${results.length} ingredients:',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppSpacing.md),
        // ⬇️ Show a scrollable list of chips
        Expanded(
          child: SingleChildScrollView(
            child: Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: results.map((item) {
                return Chip(
                  label: Text(item.name),
                  labelStyle: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500),
                  avatar: const Icon(Icons.check, size: 16),
                  backgroundColor: AppColors.backgroundNeutral,
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        // ⬇️ The "Find Recipes" button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () => _findRecipes(context, ref, ingredientNames),
            child: const Text('Find Recipes'),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
