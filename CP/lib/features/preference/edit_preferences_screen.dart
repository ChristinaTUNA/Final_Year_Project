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
    // 1. Load existing data from Firebase when screen opens
    // We use microtask to avoid building-while-building errors
    Future.microtask(() => ref
        .read(preferenceViewModelProvider.notifier)
        .loadExistingPreferences());
  }

  Future<void> _onSave() async {
    // 2. Save changes to Firebase
    await ref.read(preferenceViewModelProvider.notifier).savePreferences();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preferences updated successfully!'),
          backgroundColor: AppColors.primary,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(preferenceViewModelProvider);
    final viewModel = ref.read(preferenceViewModelProvider.notifier);
    final textTheme = Theme.of(context).textTheme;

    // Show loading while fetching current prefs
    if (state.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('My Preferences'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _onSave,
            child: const Text('Save', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.pAllLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SECTION 1: DIETARY ---
            Text('Dietary Requirements', style: textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                'Vegetarian',
                'Vegan',
                'Gluten-Free',
                'Dairy-Free',
                'Keto',
                'No preferences'
              ].map((diet) {
                final isSelected = state.dietaryPrefs.contains(diet);
                return _buildChip(
                  label: diet,
                  isSelected: isSelected,
                  onTap: () => viewModel.toggleDietaryPref(diet),
                );
              }).toList(),
            ),

            const Divider(height: 32),

            // --- SECTION 2: COOKING TIME ---
            Text('Cooking Time', style: textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                '15 min or less',
                '15 - 30 min',
                '30 - 60 min',
                '60+ min'
              ].map((time) {
                final isSelected = state.timePref == time;
                return _buildChip(
                  label: time,
                  isSelected: isSelected,
                  onTap: () => viewModel.setTimePref(time),
                );
              }).toList(),
            ),

            const Divider(height: 32),

            // --- SECTION 3: SERVINGS ---
            Text('Servings', style: textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['Just me', 'Me + partner', '3 - 4 people', '5+ people']
                  .map((serving) {
                final isSelected = state.servingsPref.contains(serving);
                return _buildChip(
                  label: serving,
                  isSelected: isSelected,
                  onTap: () => viewModel.toggleServingsPref(serving),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable Chip Widget
  Widget _buildChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.primary,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? AppColors.primary : Colors.grey.shade300,
        ),
      ),
    );
  }
}
