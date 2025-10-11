import 'package:flutter/material.dart';
import 'home/home_screen.dart';
import 'explore_screen.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;
  final _pages = const [HomeScreen(), ExploreScreen(), SizedBox(), SizedBox()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
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
                  color: _index == 0
                      ? const Color(0xFFE02200)
                      : const Color(0xFF9CA3AF)),
              onPressed: () => setState(() => _index = 0),
            ),
            IconButton(
              icon: Icon(Icons.restaurant_menu,
                  color: _index == 1
                      ? const Color(0xFFE02200)
                      : const Color(0xFF9CA3AF)),
              onPressed: () => setState(() => _index = 1),
            ),
            const SizedBox(width: 56),
            IconButton(
              icon: Icon(Icons.grid_view,
                  color: _index == 2
                      ? const Color(0xFFE02200)
                      : const Color(0xFF9CA3AF)),
              onPressed: () => setState(() => _index = 2),
            ),
            IconButton(
              icon: Icon(Icons.person_outline,
                  color: _index == 3
                      ? const Color(0xFFE02200)
                      : const Color(0xFF9CA3AF)),
              onPressed: () => setState(() => _index = 3),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE02200),
        onPressed: () {},
        child: const Icon(Icons.camera_alt, color: Colors.white),
      ),
    );
  }
}
