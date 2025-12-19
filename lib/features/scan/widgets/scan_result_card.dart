import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/data/models/scanned_ingredient.dart';
import 'package:flutter/material.dart';

class ScanResultChip extends StatelessWidget {
  final ScannedIngredient ingredient;
  final bool isSelected;
  final VoidCallback onTap;

  const ScanResultChip({
    super.key,
    required this.ingredient,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Logic: Show quantity if it's not "1" (e.g., "3 onions" vs "onion")
    String label = ingredient.name;
    if (ingredient.quantity != '1') {
      label = "${ingredient.quantity} ${ingredient.name}";
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: 1.5,
          ),
          // Removed shadow for a cleaner, flatter look
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Add a checkmark if selected
            if (isSelected) ...[
              const Icon(Icons.check, color: AppColors.primary, size: 18),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScanAddButton extends StatelessWidget {
  final VoidCallback onTap;

  const ScanAddButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // Soft primary background
          color: AppColors.primary.withValues(alpha: 0.1),
          border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3), width: 1.5),
        ),
        child: const Icon(Icons.add, color: AppColors.primary, size: 24),
      ),
    );
  }
}
