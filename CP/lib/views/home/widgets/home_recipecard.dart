import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/recipe_model.dart';

class HomeRecipeCard extends StatelessWidget {
  final Recipe recipe;

  const HomeRecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              recipe.image,
              height: 160,
              width: 280,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF5F3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(recipe.title,
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Color(0xFFFFA500), size: 18),
                    const SizedBox(width: 4),
                    Text(recipe.rating.toString(),
                        style: GoogleFonts.poppins()),
                    const SizedBox(width: 12),
                    const CircleAvatar(
                        radius: 3, backgroundColor: Color(0xFFE5E7EB)),
                    const SizedBox(width: 12),
                    Text(recipe.time, style: GoogleFonts.poppins()),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(recipe.subtitle1,
                        style: GoogleFonts.poppins(
                            color: const Color(0xFF6B7280))),
                    const SizedBox(width: 12),
                    Text('•',
                        style: GoogleFonts.poppins(
                            color: const Color(0xFF9CA3AF))),
                    const SizedBox(width: 12),
                    Text(recipe.subtitle2,
                        style: GoogleFonts.poppins(
                            color: const Color(0xFF6B7280))),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
