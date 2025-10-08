import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../viewmodels/onboarding_viewmodel.dart';

/// Back arrow positioned at top-left of onboarding
class OnboardingBackButton extends ConsumerWidget {
  final PageController controller;

  const OnboardingBackButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(onboardingProvider);
    final viewModel = ref.read(onboardingProvider.notifier);

    return Positioned(
      top: 50,
      left: 16,
      child: SafeArea(
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () {
            if (currentPage > 0) {
              controller.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              viewModel.setPage(currentPage - 1);
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }
}
