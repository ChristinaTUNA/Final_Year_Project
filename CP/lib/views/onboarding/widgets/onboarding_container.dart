// onboarding_buttons.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../viewmodels/onboarding_viewmodel.dart';
import 'onboarding_content.dart';
import 'onboarding_controls.dart';
import 'onboarding_dots.dart';

class OnboardingButtons extends ConsumerWidget {
  final PageController controller;

  const OnboardingButtons({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(onboardingProvider);
    final viewModel = ref.read(onboardingProvider.notifier);
    final onboardingData = viewModel.pages;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 24),
                OnboardingContent(data: onboardingData[currentPage]),
                const SizedBox(height: 32),
                OnboardingDots(
                  count: onboardingData.length,
                  currentIndex: currentPage,
                ),
                const SizedBox(height: 32),
                OnboardingControls(
                  controller: controller,
                  viewModel: viewModel,
                  currentPage: currentPage,
                  pageCount: onboardingData.length,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
