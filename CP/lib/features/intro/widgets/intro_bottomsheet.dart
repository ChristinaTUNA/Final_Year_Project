import 'package:cookit/core/theme/app_borders.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../intro_viewmodel.dart';
import 'intro_content.dart';
import 'intro_controls.dart';
import 'intro_dots.dart';

class IntroBottomSheet extends ConsumerWidget {
  final PageController controller;

  const IntroBottomSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(introViewModelProvider);
    final viewModel = ref.read(introViewModelProvider.notifier);
    final theme = Theme.of(context);

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: AppBorders.pVerticleTopLg,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: AppSpacing.lg), // 24px
                IntroContent(data: state.pages[state.currentPage]),
                const SizedBox(height: AppSpacing.xl), // 32px
                IntroDots(
                  count: state.pages.length,
                  currentIndex: state.currentPage,
                ),
                const SizedBox(height: AppSpacing.xl), // 32px
                IntroControls(
                  onNext: () =>
                      viewModel.onNextButtonPressed(context, controller),
                  onSkip: () =>
                      viewModel.onSkipButtonPressed(context, controller),
                  currentPage: state.currentPage,
                  pageCount: state.pages.length,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
