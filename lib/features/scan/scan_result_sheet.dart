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
  final Set<String> _unselectedIngredients = {};

  void _toggleSelection(String name) {
    setState(() {
      if (_unselectedIngredients.contains(name)) {
        _unselectedIngredients.remove(name);
      } else {
        _unselectedIngredients.add(name);
      }
    });
  }

  Future<void> _showAddDialog() async {
    String newName = '';
    await showDialog(
      context: context,
      builder: (context) {
        // Use a StatefulBuilder to manage local validation state if needed,
        // or just keep it simple.
        return AlertDialog(
          title: const Text('Add Ingredient'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: TextField(
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              hintText: 'e.g. Garlic',
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onChanged: (val) => newName = val,
            onSubmitted: (val) {
              _submitAdd(val);
              Navigator.pop(context);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                _submitAdd(newName);
                Navigator.pop(context);
              },
              child: const Text('Add',
                  style: TextStyle(
                      color: AppColors.primary, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _submitAdd(String name) {
    if (name.trim().isNotEmpty) {
      ref.read(scanViewModelProvider.notifier).addManualIngredient(name.trim());
      // No need to set local state, VM updates automatically
    }
  }

  Future<void> _addToPantry(List<ScannedIngredient> allResults) async {
    final selectedItems = allResults
        .where((item) => !_unselectedIngredients.contains(item.name))
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
            behavior: SnackBarBehavior.floating,
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

  void _findRecipes(List<ScannedIngredient> allResults) {
    final selectedItems = allResults
        .where((item) => !_unselectedIngredients.contains(item.name))
        .map((item) => item.name)
        .toList();

    if (selectedItems.isEmpty) return;

    final query = selectedItems.join(',');
    ref.read(exploreSearchQueryProvider.notifier).state = query;
    ref.read(rootShellProvider.notifier).setIndex(1); // Go to Explore Tab
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(scanViewModelProvider);
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  scanState.isLoading ? 'Analyzing...' : 'Ingredients Found',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                if (!scanState.isLoading &&
                    scanState.value?.ingredients != null)
                  Text(
                    '${scanState.value!.ingredients!.length} items',
                    style: textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
              ],
            ),
          ),

          // Content Area
          Expanded(
            child: scanState.when(
              loading: () => _buildLoadingIndicator(),
              error: (err, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text('Could not analyze image.\nError: $err',
                      textAlign: TextAlign.center),
                ),
              ),
              data: (state) {
                final results = state.ingredients;

                if (results == null) return const SizedBox();

                if (results.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off,
                            size: 48, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        const Text(
                          "No ingredients detected.",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: _showAddDialog,
                          child: const Text('Add Manually'),
                        ),
                      ],
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ...results.map((item) {
                        final isSelected =
                            !_unselectedIngredients.contains(item.name);

                        return ScanResultChip(
                          ingredient: item,
                          isSelected: isSelected,
                          onTap: () => _toggleSelection(item.name),
                        );
                      }),
                      // Add Button at the end of the list
                      ScanAddButton(onTap: _showAddDialog),
                    ],
                  ),
                );
              },
            ),
          ),

          // Bottom Buttons
          if (!scanState.isLoading &&
              scanState.value?.ingredients != null &&
              scanState.value!.ingredients!.isNotEmpty)
            _buildBottomButtons(context, scanState.value!.ingredients!),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(
      BuildContext context, List<ScannedIngredient> allResults) {
    // Calculate how many are actually selected
    final selectedCount = allResults
        .where((i) => !_unselectedIngredients.contains(i.name))
        .length;
    final hasSelection = selectedCount > 0;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          // Add to Pantry
          Expanded(
            child: SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: hasSelection ? () => _addToPantry(allResults) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[200],
                  disabledForegroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Add ($selectedCount)',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Find Recipes
          Expanded(
            child: SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: hasSelection ? () => _findRecipes(allResults) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFEECE9),
                  foregroundColor: AppColors.primary,
                  disabledBackgroundColor: Colors.grey[100],
                  disabledForegroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Find Recipes',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 3,
          ),
          const SizedBox(height: 16),
          Text(
            "Analyzing ingredients...",
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
