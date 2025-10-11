import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeCategoryChips extends StatelessWidget {
  const HomeCategoryChips({super.key});

  @override
  Widget build(BuildContext context) {
    final items = ['Japanese', 'Mexican', 'Italian', 'Vegan', 'Chinese'];

    return SizedBox(
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Column(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFFFFE6E0),
                child: Text(
                  items[index][0],
                  style: GoogleFonts.poppins(
                    color: const Color(0xFFE02200),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(items[index], style: GoogleFonts.poppins(fontSize: 12)),
            ],
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemCount: items.length,
      ),
    );
  }
}
