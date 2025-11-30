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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            // Red border if selected, Grey if not
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Text(
          ingredient.name,
          style: TextStyle(
            // Red text if selected, Black if not
            color: isSelected ? AppColors.primary : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 15,
          ),
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
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFFFD1CA), width: 1.5),
        ),
        child: const Icon(Icons.add, color: AppColors.primary),
      ),
    );
  }
}
