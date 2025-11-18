import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:cookit/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'preference_viewmodel.dart';
import 'widgets/preference_progressbar.dart';
import 'widgets/preference_chip.dart';

class PreferenceScreen extends ConsumerStatefulWidget {
  const PreferenceScreen({super.key});

  @override
  ConsumerState<PreferenceScreen> createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends ConsumerState<PreferenceScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();

    final initialPage = ref.read(preferenceProvider).currentPage;
    _pageController = PageController(initialPage: initialPage);

    // Sync PageView with ViewModel
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;

      if (page != ref.read(preferenceProvider).currentPage) {
        ref.read(preferenceProvider.notifier).setPage(page);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(preferenceProvider);
    final viewModel = ref.read(preferenceProvider.notifier);
    final textTheme = Theme.of(context).textTheme;

    const dietaryOptions = [
      'Dairy-Free',
      'Keto',
      'Gluten-Free',
      'Low Carbs',
      'Vegetarian',
      'Paleo',
      'Vegan',
      'No preferences',
    ];
    const timeOptions = [
      '15 min or less',
      '15 - 30 min',
      '30 - 60 min',
      '60+ min'
    ];
    const servingsOptions = [
      'Just me',
      'Me + partner',
      '3 - 4 people',
      '5+ people'
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textTheme.bodyLarge?.color),
          onPressed: () => viewModel.back(context, _pageController),
        ),
        actions: [
          TextButton(
            onPressed: () => viewModel.skip(context),
            child: Text(
              'Skip',
              style: AppTextStyles.button.copyWith(color: AppColors.primary),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: Padding(
        padding: AppSpacing.pHorizontalLg, // 24px
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PreferenceProgressbar(currentPage: state.currentPage),
            const SizedBox(height: AppSpacing.xl), // 32px
            Expanded(
              child: PageView(
                controller: _pageController,
                children: [
                  _buildPage(
                    title: 'Tell us your dietary restrictions or preferences',
                    options: dietaryOptions,
                    isMultiSelect: true,
                    selected: state.dietaryPrefs,
                    onTap: (pref) => viewModel.toggleDietaryPref(pref),
                  ),
                  // --- Page 2: Time ---
                  _buildPage(
                    title: 'How much time do you prefer spending?',
                    options: timeOptions,
                    isMultiSelect: false,
                    selected: state.timePref,
                    onTap: (pref) => viewModel.setTimePref(pref),
                  ),
                  // --- Page 3: Servings ---
                  _buildPage(
                    title: 'How many people do you usually cook for?',
                    options: servingsOptions,
                    isMultiSelect: true,
                    selected: state.servingsPref,
                    onTap: (pref) => viewModel.toggleServingsPref(pref),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: AppSpacing.pAllXl.copyWith(top: AppSpacing.md),
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: () => viewModel.next(context, _pageController),
            child: const Text('Next'),
          ),
        ),
      ),
    );
  }

  Widget _buildPage({
    required String title,
    required List<String> options,
    required dynamic selected,
    required bool isMultiSelect,
    required ValueChanged<String> onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(height: AppSpacing.lg), // 24px
        Wrap(
          spacing: AppSpacing.sm, // 12px
          runSpacing: AppSpacing.sm, // 12px
          children: options.map((option) {
            bool isSelected;
            if (isMultiSelect) {
              isSelected = (selected as Set<String>).contains(option);
            } else {
              isSelected = (selected as String?) == option;
            }
            return PreferenceChip(
              label: option,
              isSelected: isSelected,
              onTap: () => onTap(option),
            );
          }).toList(),
        ),
      ],
    );
  }
}
