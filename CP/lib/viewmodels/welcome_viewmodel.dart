import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final welcomeViewModelProvider =
    ChangeNotifierProvider<WelcomeViewModel>((ref) => WelcomeViewModel());

class WelcomeViewModel extends ChangeNotifier {
  AnimationController? _bounceController;
  Animation<double>? _bounce;
  bool initialized = false;

  Animation<double> get bounce => _bounce ?? const AlwaysStoppedAnimation(1.0);

  void init(TickerProvider ticker) {
    if (initialized) return;

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: ticker,
    )..repeat(reverse: true);

    _bounce = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _bounceController!, curve: Curves.elasticInOut),
    );

    initialized = true;
    Future.microtask(notifyListeners);
  }

  @override
  void dispose() {
    _bounceController?.dispose();
    super.dispose();
  }
}
