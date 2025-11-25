import 'package:flutter_riverpod/flutter_riverpod.dart';

/// This Notifier simply holds the integer for the
/// currently active tab index in the BottomNavigationBar.
class RootShellViewModel extends Notifier<int> {
  @override
  int build() {
    // Default to the first tab (index 0)
    return 0;
  }

  /// Sets the active tab to the new index.
  void setIndex(int index) {
    state = index;
  }
}

/// The provider for the RootShell's state.
final rootShellProvider = NotifierProvider<RootShellViewModel, int>(
  () => RootShellViewModel(),
);
