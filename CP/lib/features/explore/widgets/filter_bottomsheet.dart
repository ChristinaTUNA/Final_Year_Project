import 'package:cookit/core/theme/app_borders.dart';
import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cookit/data/models/filter_state.dart';
import 'package:cookit/features/explore/explore_viewmodel.dart';

class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  // Local state for the sheet (before applying)
  late FilterState _localState;

  // Define Options
  final _sortOptions = ['Prep Time', 'Servings', 'Ratings', 'Popularity'];
  final _cuisineOptions = [
    'Fast food',
    'Dessert',
    'Beverages',
    'Indian',
    'Chinese',
    'French',
    'Italian',
    'Mexican',
    'Japanese'
  ];
  final _tagOptions = [
    'Keto',
    'Dairy Free',
    'Vegetarian',
    'Low Carbs',
    'Gluten Free'
  ];

  @override
  void initState() {
    super.initState();
    // Initialize local state from the global provider
    _localState = ref.read(exploreFilterStateProvider);
  }

  void _toggleSort(String value) {
    setState(() {
      // Toggle off if already selected
      if (_localState.sortBy == value) {
        _localState = _localState.copyWith(sortBy: '');
      } else {
        _localState = _localState.copyWith(sortBy: value);
      }
    });
  }

  void _toggleCuisine(String value) {
    setState(() {
      final newSet = Set<String>.from(_localState.cuisines);
      if (newSet.contains(value)) {
        newSet.remove(value);
      } else {
        newSet.add(value);
      }
      _localState = _localState.copyWith(cuisines: newSet);
    });
  }

  void _toggleTag(String value) {
    setState(() {
      final newSet = Set<String>.from(_localState.tags);
      if (newSet.contains(value)) {
        newSet.remove(value);
      } else {
        newSet.add(value);
      }
      _localState = _localState.copyWith(tags: newSet);
    });
  }

  void _applyFilters() {
    // Update the global provider
    ref.read(exploreFilterStateProvider.notifier).state = _localState;
    Navigator.pop(context);
  }

  void _removeAll() {
    setState(() {
      _localState = const FilterState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85, // 85% height
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // 1. Header
          Padding(
            padding: AppSpacing.pAllLg,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
                Text('Filters', style: textTheme.headlineSmall),
                // Placeholder for spacing balance or "532 results"
                const SizedBox(width: 48),
              ],
            ),
          ),
          const Divider(height: 1),

          // 2. Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: AppSpacing.pAllLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Sort by', textTheme),
                  _buildWrap(
                    options: _sortOptions,
                    isSelected: (val) => _localState.sortBy == val,
                    onTap: _toggleSort,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _buildSectionHeader('Cuisine', textTheme),
                  _buildWrap(
                    options: _cuisineOptions,
                    isSelected: (val) => _localState.cuisines.contains(val),
                    onTap: _toggleCuisine,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _buildSectionHeader('Tags', textTheme),
                  _buildWrap(
                    options: _tagOptions,
                    isSelected: (val) => _localState.tags.contains(val),
                    onTap: _toggleTag,
                  ),
                ],
              ),
            ),
          ),

          // 3. Bottom Buttons
          Padding(
            padding: AppSpacing.pAllLg,
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: OutlinedButton(
                      onPressed: _removeAll,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        foregroundColor: AppColors.primary,
                        shape: const RoundedRectangleBorder(
                            borderRadius: AppBorders.allMd),
                      ),
                      child: const Text('Remove all'),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _applyFilters,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.primary, // Pale red/pink in image?
                        foregroundColor:
                            AppColors.white, // Or primary if bg is pale
                        shape: const RoundedRectangleBorder(
                            borderRadius: AppBorders.allMd),
                        elevation: 0,
                      ),
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Text(title, style: textTheme.titleMedium),
    );
  }

  Widget _buildWrap({
    required List<String> options,
    required bool Function(String) isSelected,
    required Function(String) onTap,
  }) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: options.map((option) {
        final selected = isSelected(option);
        return GestureDetector(
          onTap: () => onTap(option),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : Colors.white,
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.divider,
              ),
              borderRadius: BorderRadius.circular(30), // Rounder chips
            ),
            child: Text(
              option,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.textGray,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
