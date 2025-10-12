import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeCategoryChips extends StatelessWidget {
  const HomeCategoryChips({super.key});

  @override
  Widget build(BuildContext context) {
    final items = ['Japanese', 'Mexican', 'Italian', 'Vegan', 'Chinese'];

    final icons = [
      'assets/images/icon_japanese.png',
      'assets/images/icon_mexican.png',
      'assets/images/icon_italian.png',
      'assets/images/icon_vegan.png',
      'assets/images/icon_chinese.png',
    ];

    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemBuilder: (context, index) {
          return Column(
            children: [
              // Circular background for icon
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFFFFE6E0),
                child: Image.asset(
                  icons[index],
                  height: 28,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 8),
              // Label below icon
              Text(
                items[index],
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF4B5563),
                ),
              ),
            ],
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemCount: items.length,
      ),
    );
  }
}
