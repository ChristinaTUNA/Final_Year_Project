import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

/// Provider for the Splash screen state
final splashProvider =
    NotifierProvider<SplashViewModel, bool>(SplashViewModel.new);

class SplashViewModel extends Notifier<bool> {
  @override
  bool build() {
    // Schedule after build to avoid side effects during initialization
    Future<void>.microtask(() async {
      await Future<void>.delayed(const Duration(seconds: 4));
      state = true; // Notify splash finished
    });
    return false;
  }
}
