import 'package:cookit/features/chatbot/chatbot_screen.dart';
import 'package:cookit/features/explore/explore_screen.dart';
import 'package:cookit/features/home/home_screen.dart';
import 'package:cookit/features/lists/lists_screen.dart';
import 'package:cookit/features/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'root_shell_viewmodel.dart';

class RootShell extends ConsumerWidget {
  const RootShell({super.key});

  // ⬇️ The 4 main tabs (indexed 0, 1, 2, 3)
  // Chatbot is NOT in this list because it's a floating button, not a tab.
  final List<Widget> _pages = const [
    HomeScreen(),
    ExploreScreen(),
    ListsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ⬇️ CRITICAL: Watch the provider so the tab switches when requested
    // (e.g. from HomeHeader or SearchBar)
    final currentIndex = ref.watch(rootShellProvider);
    final viewModel = ref.read(rootShellProvider.notifier);

    return Scaffold(
      body: Stack(
        children: [
          // 1. The Main Tab Content
          _pages[currentIndex],

          // 2. The Floating "Chef" Chatbot Button (Bottom Right)
          // Kept your exact positioning and styling
          Positioned(
            right: 18,
            bottom: 30, // Sits above the bottom bar area
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ChatbotScreen()),
              ),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: const Color(0xFFE02200), width: 0.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .12),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/chef_mato_f.png',
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, st) =>
                        const Icon(Icons.chat, color: Color(0xFFE02200)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // Center "Scan" Button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          backgroundColor: const Color(0xFFE02200),
          splashColor: Colors.white.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          tooltip: 'Scan with camera',
          // ⬇️ CONNECTED: Navigate to Scan Screen
          onPressed: () {
            Navigator.pushNamed(context, '/scan');
          },
          child: const Icon(Icons.camera_alt, color: Colors.white, size: 32),
        ),
      ),

      // ⬇️ Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        height: 78,
        color: Colors.white,
        notchMargin: 8,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Home (Index 0)
            IconButton(
              icon: Icon(
                Icons.home,
                size: 28,
                color: currentIndex == 0
                    ? const Color(0xFFE02200)
                    : const Color(0xFF9CA3AF),
              ),
              onPressed: () => viewModel.setIndex(0),
            ),
            // Explore (Index 1)
            IconButton(
              icon: Icon(
                Icons.restaurant_menu,
                size: 24,
                color: currentIndex == 1
                    ? const Color(0xFFE02200)
                    : const Color(0xFF9CA3AF),
              ),
              onPressed: () => viewModel.setIndex(1),
            ),

            const SizedBox(width: 56), // Gap for the big FAB

            // Lists (Index 2)
            IconButton(
              icon: Icon(
                Icons.list,
                size: 32,
                color: currentIndex == 2
                    ? const Color(0xFFE02200)
                    : const Color(0xFF9CA3AF),
              ),
              onPressed: () => viewModel.setIndex(2),
            ),
            // Profile (Index 3)
            IconButton(
              icon: Icon(
                Icons.person_outline,
                size: 28,
                color: currentIndex == 3
                    ? const Color(0xFFE02200)
                    : const Color(0xFF9CA3AF),
              ),
              onPressed: () => viewModel.setIndex(3),
            ),
          ],
        ),
      ),
    );
  }
}
