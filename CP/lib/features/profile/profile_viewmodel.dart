import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileViewModel extends AsyncNotifier<User?> {
  late final FirebaseAuth _auth;

  @override
  Future<User?> build() async {
    _auth = ref.watch(firebaseAuthProvider);
    // This stream will automatically update and re-build the UI
    // whenever the user logs in or out.
    return _auth.authStateChanges().first;
  }

  /// Signs the user out of Firebase.
  Future<void> signOut() async {
    // We don't need to update the state here,
    // the 'authStateChanges()' stream will do it for us.
    await _auth.signOut();
  }
}

// Simple provider for the FirebaseAuth instance
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// The main provider your ProfileScreen will watch
final profileViewModelProvider = AsyncNotifierProvider<ProfileViewModel, User?>(
  () => ProfileViewModel(),
);
