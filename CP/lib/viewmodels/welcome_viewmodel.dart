import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final welcomeViewModelProvider =
    ChangeNotifierProvider<WelcomeViewModel>((ref) => WelcomeViewModel());

class WelcomeViewModel extends ChangeNotifier {
  late AnimationController bounceController;
  late Animation<double> bounce;
  bool initialized = false;

  void init(TickerProvider ticker) {
    bounceController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: ticker,
    )..repeat(reverse: true);

    bounce = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: bounceController, curve: Curves.easeInOut),
    );

    initialized = true;
    notifyListeners();
  }

  @override
  void dispose() {
    bounceController.dispose();
    super.dispose();
  }
}
