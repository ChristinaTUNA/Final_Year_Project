import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/data/models/list_item.dart';
import 'package:cookit/data/models/scanned_ingredient.dart';
import 'package:cookit/data/services/user_database_service.dart';
import 'package:cookit/features/explore/explore_viewmodel.dart';

import 'package:cookit/features/scan/scan_viewmodel.dart';
import 'package:cookit/features/scan/widgets/scan_result_card.dart';
import 'package:cookit/features/shared/root_shell_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScanResultsSheet extends ConsumerStatefulWidget {
  const ScanResultsSheet({super.key});

  @override
  ConsumerState<ScanResultsSheet> createState() => _ScanResultsSheetState();
}

class _ScanResultsSheetState extends ConsumerState<ScanResultsSheet> {
  Future<void> _showAddDialog() async {
    String newName = '';
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Ingredient'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(hintText: 'e.g. Garlic'),
          onChanged: (val) => newName = val,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (newName.isNotEmpty) {
                ref
                    .read(scanViewModelProvider.notifier)
                    .addManualIngredient(newName);
                // No need to set local state, VM updates automatically
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _addToPantry(List<ScannedIngredient> allResults) async {
    //  Get selection from ViewModel state
    final selectedSet =
        ref.read(scanViewModelProvider).value?.selectedIngredients ?? {};

    final selectedItems = allResults
        .where((item) => selectedSet.contains(item.name))
        .map((scanned) => ListItem(
              name: scanned.name,
              category: scanned.category,
              quantity: scanned.quantity,
            ))
        .toList();

    if (selectedItems.isEmpty) return;

    try {
      await ref
          .read(userDatabaseServiceProvider)
          .addItems(selectedItems, 'pantry');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added ${selectedItems.length} items to Pantry!'),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _findRecipes() {
    // Get selection from ViewModel state
    final selectedSet =
        ref.read(scanViewModelProvider).value?.selectedIngredients ?? {};

    if (selectedSet.isEmpty) return;

    final query = selectedSet.join(',');
    ref.read(exploreSearchQueryProvider.notifier).state = query;
    ref.read(rootShellProvider.notifier).setIndex(1); // Go to Explore Tab
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(scanViewModelProvider);
    final viewModel = ref.read(scanViewModelProvider.notifier);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Text(
              scanState.isLoading ? 'Scanning...' : 'Ingredients found..',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Content Area
          Expanded(
            child: scanState.isLoading
                ? _buildLoadingIndicator()
                : scanState.when(
                    loading: () => _buildLoadingIndicator(),
                    error: (err, stack) => Center(child: Text('Error: $err')),
                    data: (state) {
                      final results = state.ingredients;
                      if (results == null) return const SizedBox();

                      if (results.isEmpty) {
                        return const Center(
                            child: Text("No ingredients found."));
                      }

                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            ...results.map((item) {
                              // ⬇️ Check selection against ViewModel state
                              final isSelected =
                                  state.selectedIngredients.contains(item.name);
                              return ScanResultChip(
                                ingredient: item,
                                isSelected: isSelected,
                                // ⬇️ Call ViewModel to toggle
                                onTap: () =>
                                    viewModel.toggleSelection(item.name),
                              );
                            }),
                            ScanAddButton(onTap: _showAddDialog),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          // Bottom Buttons (Only show if NOT loading and data exists)
          if (!scanState.isLoading && scanState.value?.ingredients != null)
            _buildBottomButtons(
                context, ref, scanState.value!.selectedIngredients),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(
      BuildContext context, WidgetRef ref, Set<String> selected) {
    final hasSelection = selected.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: hasSelection
                    ? () => _addToPantry(
                        ref.read(scanViewModelProvider).value!.ingredients!)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Add to Pantry',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: hasSelection ? _findRecipes : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFEECE9),
                  foregroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Find recipes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
        strokeWidth: 3,
      ),
    );
  }
}
