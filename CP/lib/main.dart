import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_router.dart'; // ⬅️ for cleaner route management

void main() {
  runApp(const ProviderScope(child: CookitApp()));
}

class CookitApp extends ConsumerWidget {
  const CookitApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'COOKIT',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFFE02200), // red accent for consistency
        fontFamily: 'Poppins', // optional global font
      ),
      initialRoute: AppRouter.initialRoute,
      onGenerateRoute: AppRouter.generateRoute, // 💡 central navigation control
    );
  }
}
