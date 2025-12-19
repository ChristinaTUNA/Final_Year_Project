import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../preference/preference_viewmodel.dart';

class MyPreferencesScreen extends ConsumerStatefulWidget {
  const MyPreferencesScreen({super.key});

  @override
  ConsumerState<MyPreferencesScreen> createState() =>
      _MyPreferencesScreenState();
}

class _MyPreferencesScreenState extends ConsumerState<MyPreferencesScreen> {
  @override
  void initState() {
    super.initState();
    // Load data without triggering a rebuild during init
    Future.microtask(() => ref
        .read(preferenceViewModelProvider.notifier)
        .loadExistingPreferences());
  }

  Future<void> _onSave() async {
    // Show loading indicator on button logic handled by state
    try {
      await ref.read(preferenceViewModelProvider.notifier).savePreferences();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Preferences updated successfully!'),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving preferences: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(preferenceViewModelProvider);
    final viewModel = ref.read(preferenceViewModelProvider.notifier);
    final textTheme = Theme.of(context).textTheme;

    // Use a Stack to show loading overlay if needed, or just rely on button state
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('My Preferences'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: state.isLoading ? null : _onSave,
            child: state.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
      body: state.isLoading && state.dietaryPrefs.isEmpty
          // Show full loader only on initial load if data is empty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: AppSpacing.pAllLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(textTheme, 'Dietary Requirements'),
                  const SizedBox(height: AppSpacing.md),
                  _buildChipGroup(
                    options: [
                      'Vegetarian',
                      'Vegan',
                      'Gluten-Free',
                      'Dairy-Free',
                      'Keto',
                      'No preferences'
                    ],
                    selectedSet: state.dietaryPrefs,
                    onTap: (val) => viewModel.toggleDietaryPref(val),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Divider(height: 1, color: AppColors.divider),
                  ),

                  _buildSectionHeader(textTheme, 'Cooking Time'),
                  const SizedBox(height: AppSpacing.md),
                  _buildChipGroup(
                    options: [
                      '15 min or less',
                      '15 - 30 min',
                      '30 - 60 min',
                      '60+ min'
                    ],
                    // Convert single string to set for uniform handling
                    selectedSet:
                        state.timePref != null ? {state.timePref!} : {},
                    onTap: (val) => viewModel.setTimePref(val),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Divider(height: 1, color: AppColors.divider),
                  ),

                  _buildSectionHeader(textTheme, 'Servings'),
                  const SizedBox(height: AppSpacing.md),
                  _buildChipGroup(
                    options: [
                      'Just me',
                      'Me + partner',
                      '3 - 4 people',
                      '5+ people'
                    ],
                    selectedSet: state.servingsPref,
                    onTap: (val) => viewModel.toggleServingsPref(val),
                  ),

                  const SizedBox(height: 50), // Bottom padding
                ],
              ),
            ),
    );
  }

  Widget _buildSectionHeader(TextTheme textTheme, String title) {
    return Text(
      title,
      style: textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
    );
  }

  Widget _buildChipGroup({
    required List<String> options,
    required Set<String> selectedSet,
    required Function(String) onTap,
  }) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((option) {
        final isSelected = selectedSet.contains(option);
        return ChoiceChip(
          label: Text(option),
          selected: isSelected,
          onSelected: (_) => onTap(option),

          // Customizing Colors
          selectedColor: AppColors.primary,
          backgroundColor: Colors.white,
          disabledColor: Colors.grey[200],

          // Border
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected ? AppColors.primary : Colors.grey.shade300,
              width: 1,
            ),
          ),

          // Text Style
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        );
      }).toList(),
    );
  }
}
