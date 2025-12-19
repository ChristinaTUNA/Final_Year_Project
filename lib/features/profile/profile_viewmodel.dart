import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.userChanges();
});

// This provider handles ACTIONS (Logout, Update)
final profileViewModelProvider =
    StateNotifierProvider<ProfileViewModel, AsyncValue<void>>((ref) {
  return ProfileViewModel(FirebaseAuth.instance);
});

class ProfileViewModel extends StateNotifier<AsyncValue<void>> {
  final FirebaseAuth _auth;

  ProfileViewModel(this._auth) : super(const AsyncData(null));

  Future<void> updateDisplayName(String newName) async {
    state = const AsyncLoading();
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(newName);
        await user.reload(); // Force refresh
      }
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    try {
      await _auth.signOut();
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
