import '../lists/lists_screen.dart';
import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../explore/explore_screen.dart';
import '../profile/profile_screen.dart';
import '../chatbot/chatbot_screen.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;
  final _pages = const [
    HomeScreen(),
    ExploreScreen(),
    ListsScreen(),
    ProfileScreen(),
    ChatbotScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_index],
          // Chef FAB at bottom-right
          Positioned(
            right: 18,
            bottom: 18,
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ChatbotScreen())),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE02200), width: 1),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 4)),
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
      bottomNavigationBar: BottomAppBar(
        height: 78,
        color: Colors.white,
        notchMargin: 8,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home,
                  size: 28,
                  color: _index == 0
                      ? const Color(0xFFE02200)
                      : const Color(0xFF9CA3AF)),
              onPressed: () => setState(() => _index = 0),
            ),
            IconButton(
              icon: Icon(Icons.restaurant_menu,
                  size: 24,
                  color: _index == 1
                      ? const Color(0xFFE02200)
                      : const Color(0xFF9CA3AF)),
              onPressed: () => setState(() => _index = 1),
            ),
            const SizedBox(width: 56),
            IconButton(
              icon: Icon(Icons.list,
                  size: 32,
                  color: _index == 2
                      ? const Color(0xFFE02200)
                      : const Color(0xFF9CA3AF)),
              onPressed: () => setState(() => _index = 2),
            ),
            IconButton(
              icon: Icon(Icons.person_outline,
                  size: 28,
                  color: _index == 3
                      ? const Color(0xFFE02200)
                      : const Color(0xFF9CA3AF)),
              onPressed: () => setState(() => _index = 3),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          backgroundColor: const Color(0xFFE02200),
          splashColor: Colors.white.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40), // make it round
          ),
          tooltip: 'Scan with camera',
          onPressed: () {
            Navigator.pushNamed(context, '/scan');
          },
          child: const Icon(Icons.camera_alt, color: Colors.white, size: 32),
        ),
      ),
    );
  }
}
