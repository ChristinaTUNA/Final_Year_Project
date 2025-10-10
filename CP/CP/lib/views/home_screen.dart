import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi, Emily!',
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ready to cook something delicious?',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _SearchBar(),
                    const SizedBox(height: 16),
                    _CategoryChips(),
                    const SizedBox(height: 16),
                    Text(
                      'Quick Meal',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 280,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: const [
                          _RecipeCard(
                            title: 'Hummus Avo-Toast',
                            subtitle1: 'Dairy-Free',
                            subtitle2: 'American',
                            rating: 4.8,
                            time: '5 mins',
                            image: 'assets/images/onboarding_1.webp',
                          ),
                          SizedBox(width: 16),
                          _RecipeCard(
                            title: 'Lemon-Garlic Shrimp',
                            subtitle1: 'Dairy-Free',
                            subtitle2: 'Japanese',
                            rating: 4.8,
                            time: '5 mins',
                            image: 'assets/images/onboarding_2.jpg',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Cook Now',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/onboarding_3.jpg',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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

class _CategoryChips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = ['Japanese', 'Mexican', 'Italian', 'Vegan', 'Chinese'];
    return SizedBox(
      height: 84,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Column(
            children: [
              CircleAvatar(
                radius: 26,
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
              Text(
                items[index],
                style: GoogleFonts.poppins(fontSize: 12),
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

class _RecipeCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle1;
  final String subtitle2;
  final double rating;
  final String time;

  const _RecipeCard({
    required this.image,
    required this.title,
    required this.subtitle1,
    required this.subtitle2,
    required this.rating,
    required this.time,
  });

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
              image,
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
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Color(0xFFFFA500), size: 18),
                    const SizedBox(width: 4),
                    Text(rating.toString(), style: GoogleFonts.poppins()),
                    const SizedBox(width: 12),
                    const CircleAvatar(
                        radius: 3, backgroundColor: Color(0xFFE5E7EB)),
                    const SizedBox(width: 12),
                    Text(time, style: GoogleFonts.poppins()),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(subtitle1,
                        style: GoogleFonts.poppins(
                            color: const Color(0xFF6B7280))),
                    const SizedBox(width: 12),
                    Text('•',
                        style: GoogleFonts.poppins(
                            color: const Color(0xFF9CA3AF))),
                    const SizedBox(width: 12),
                    Text(subtitle2,
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
