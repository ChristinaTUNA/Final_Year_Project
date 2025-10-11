import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.search, color: Color(0xFFE02200)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'search for food...',
              style: GoogleFonts.poppins(
                color: const Color(0xFF9CA3AF),
                fontSize: 16,
              ),
            ),
          ),
          const Icon(Icons.camera_alt_outlined, color: Color(0xFFE02200)),
        ],
      ),
    );
  }
}
