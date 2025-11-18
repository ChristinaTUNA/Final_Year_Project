import 'package:cookit/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class IntroDots extends StatelessWidget {
  final int count;
  final int currentIndex;

  const IntroDots({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: isActive ? 18 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.divider,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
