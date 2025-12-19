import 'package:cookit/core/theme/app_colors.dart';
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

  final List<Widget> _pages = const [
    HomeScreen(),
    ExploreScreen(),
    ListsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(rootShellProvider);
    final viewModel = ref.read(rootShellProvider.notifier);

    // Theme logic
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    const activeColor = AppColors.primary;
    final inactiveColor = isDark ? Colors.white54 : const Color(0xFF9CA3AF);
    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    // Calculate bottom padding to lift the chatbot above the nav bar area
    // Standard BottomAppBar height is usually around 80.
    // We add some extra buffer so it floats nicely.
    const double fabBottomPadding = 100.0;

    return Scaffold(
      extendBody: true,

      body: Stack(
        children: [
          IndexedStack(
            index: currentIndex,
            children: _pages,
          ),

          // 2. Chatbot FAB
          Positioned(
            right: 16,
            bottom: fabBottomPadding,
            child: FloatingActionButton(
              heroTag: 'chatbot_fab',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ChatbotScreen()),
              ),
              backgroundColor: Colors.white,
              elevation: 4,
              shape: const CircleBorder(),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: activeColor.withValues(alpha: 0.2), width: 1),
                ),
                padding: const EdgeInsets.all(8),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/chef_mato_f.png',
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, st) => const Icon(
                        Icons.chat_bubble_outline,
                        color: activeColor),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // 3. Central Scan FAB
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 72,
        height: 72,
        child: FloatingActionButton(
          heroTag: 'scan_fab',
          backgroundColor: activeColor,
          elevation: 4,
          shape: const CircleBorder(),
          tooltip: 'Scan Ingredients',
          onPressed: () {
            Navigator.pushNamed(context, '/scan');
          },
          child: const Icon(Icons.camera_alt_rounded,
              color: Colors.white, size: 32),
        ),
      ),

      // 4. Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        height: 80,
        color: bgColor,
        surfaceTintColor: Colors.transparent,
        notchMargin: 8,
        shape: const CircularNotchedRectangle(),
        elevation: 10,
        shadowColor: Colors.black12,
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavBarItem(
              icon: Icons.home_rounded,
              label: 'Home',
              isSelected: currentIndex == 0,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              onTap: () => viewModel.setIndex(0),
            ),
            _NavBarItem(
              icon: Icons.explore_rounded,
              label: 'Explore',
              isSelected: currentIndex == 1,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              onTap: () => viewModel.setIndex(1),
            ),

            const SizedBox(width: 48), // Spacer for FAB

            _NavBarItem(
              icon: Icons.list_alt_rounded,
              label: 'Lists',
              isSelected: currentIndex == 2,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              onTap: () => viewModel.setIndex(2),
            ),
            _NavBarItem(
              icon: Icons.person_rounded,
              label: 'Profile',
              isSelected: currentIndex == 3,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              onTap: () => viewModel.setIndex(3),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper Widget for cleaner nav items
class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 26,
              color: isSelected ? activeColor : inactiveColor,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? activeColor : inactiveColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
