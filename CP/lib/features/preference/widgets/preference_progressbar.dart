import 'package:cookit/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PreferenceProgressbar extends StatelessWidget {
  final int currentPage;

  const PreferenceProgressbar({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _ProgressStep(isActive: true),
        _ProgressLine(isActive: currentPage > 0),
        _ProgressStep(isActive: currentPage > 0),
        _ProgressLine(isActive: currentPage > 1),
        _ProgressStep(isActive: currentPage > 1),
      ],
    );
  }
}

class _ProgressLine extends StatelessWidget {
  final bool isActive;
  const _ProgressLine({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Divider(
        height: 2,
        thickness: 2,
        color: isActive ? AppColors.primary : AppColors.divider,
      ),
    );
  }
}

class _ProgressStep extends StatelessWidget {
  final bool isActive;
  const _ProgressStep({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? AppColors.primary : AppColors.background,
        border: Border.all(
          color: isActive ? AppColors.primary : AppColors.divider,
          width: 2,
        ),
      ),
      child: isActive
          ? const Icon(Icons.check, color: AppColors.white, size: 16)
          : null,
    );
  }
}
