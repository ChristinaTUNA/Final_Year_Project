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
    final initialPage = ref.read(preferenceViewModelProvider).currentPage;
    _pageController = PageController(initialPage: initialPage);

    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != ref.read(preferenceViewModelProvider).currentPage) {
        ref.read(preferenceViewModelProvider.notifier).setPage(page);
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
    final state = ref.watch(preferenceViewModelProvider);
    final viewModel = ref.read(preferenceViewModelProvider.notifier);
    final textTheme = Theme.of(context).textTheme;

    // Define Options
    const dietaryOptions = [
      'Dairy-Free',
      'Keto',
      'Gluten-Free',
      'Low Carbs',
      'Vegetarian',
      'Paleo',
      'Vegan',
      'No preferences'
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
          onPressed: state.isLoading
              ? null
              : () => viewModel.back(context, _pageController),
        ),
        actions: [
          TextButton(
            onPressed: state.isLoading ? null : () => viewModel.skip(context),
            child: Text(
              'Skip',
              style: AppTextStyles.labelLarge.copyWith(
                  color: state.isLoading ? Colors.grey : AppColors.primary),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.pHorizontalLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PreferenceProgressbar(currentPage: state.currentPage),
              const SizedBox(height: AppSpacing.xl),

              // Expanded PageView handles the main content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: state.isLoading
                      ? const NeverScrollableScrollPhysics()
                      : const BouncingScrollPhysics(),
                  children: [
                    _buildPage(
                      title: 'Tell us your dietary preferences',
                      description:
                          'We will personalize your recipe feed based on these choices.',
                      options: dietaryOptions,
                      isMultiSelect: true,
                      selected: state.dietaryPrefs,
                      isLoading: state.isLoading,
                      onTap: (pref) => viewModel.toggleDietaryPref(pref),
                    ),
                    _buildPage(
                      title: 'How much time do you have?',
                      description:
                          'We prioritize recipes that fit your schedule.',
                      options: timeOptions,
                      isMultiSelect: false,
                      selected: state.timePref,
                      isLoading: state.isLoading,
                      onTap: (pref) => viewModel.setTimePref(pref),
                    ),
                    _buildPage(
                      title: 'Who are you cooking for?',
                      description: 'We will help you match your portion sizes.',
                      options: servingsOptions,
                      isMultiSelect: true,
                      selected: state.servingsPref,
                      isLoading: state.isLoading,
                      onTap: (pref) => viewModel.toggleServingsPref(pref),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: AppSpacing.pAllXl.copyWith(top: AppSpacing.md, bottom: 32),
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: state.isLoading
                ? null
                : () => viewModel.next(context, _pageController),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              backgroundColor: AppColors.primary,
            ),
            child: state.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2))
                : const Text('Next'),
          ),
        ),
      ),
    );
  }

  Widget _buildPage({
    required String title,
    required String description,
    required List<String> options,
    required dynamic selected,
    required bool isMultiSelect,
    required bool isLoading,
    required ValueChanged<String> onTap,
  }) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  )),
          const SizedBox(height: AppSpacing.sm),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textGray,
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: 12,
            runSpacing: 12,
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
                onTap: isLoading ? () {} : () => onTap(option),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
