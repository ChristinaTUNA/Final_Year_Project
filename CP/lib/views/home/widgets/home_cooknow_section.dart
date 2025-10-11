import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/recipe_model.dart';

class HomeCookNowSection extends StatelessWidget {
  final List<Recipe> recipes;

  const HomeCookNowSection({super.key, required this.recipes});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: List.generate(recipes.length, (index) {
          final recipe = recipes[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(recipe.image,
                      width: 100, height: 100, fit: BoxFit.cover),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(recipe.title,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text('${recipe.time} • ⭐ ${recipe.rating}',
                          style: GoogleFonts.poppins(
                              color: const Color(0xFF6B7280), fontSize: 13)),
                      const SizedBox(height: 4),
                      Text('${recipe.subtitle1} • ${recipe.subtitle2}',
                          style: GoogleFonts.poppins(
                              color: const Color(0xFF9CA3AF), fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
