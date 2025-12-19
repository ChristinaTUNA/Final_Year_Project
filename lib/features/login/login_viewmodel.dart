import 'package:cookit/data/services/user_database_service.dart'; // ⬅️ Import DB Service
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:equatable/equatable.dart';

// --- STATE ---
class LoginState extends Equatable {
  final bool isLoading;
  final String? error;
  // ⬇️ CHANGED: Use a route string instead of a boolean for smarter navigation
  final String? navigationRoute;

  const LoginState({
    this.isLoading = false,
    this.error,
    this.navigationRoute,
  });

  LoginState copyWith({
    bool? isLoading,
    String? error,
    String? navigationRoute,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      navigationRoute: navigationRoute,
    );
  }

  @override
  List<Object?> get props => [isLoading, error, navigationRoute];
}

// --- VIEWMODEL ---
class LoginViewModel extends StateNotifier<LoginState> {
  final FirebaseAuth _auth;
  final UserDatabaseService _dbService; // ⬅️ Add DB Service

  LoginViewModel(this._auth, this._dbService) : super(const LoginState()) {
    _initGoogleSignIn();
  }

  // Use the Singleton instance (v7.x standard)
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  void _initGoogleSignIn() {
    _googleSignIn.initialize();
  }

  //
  Future<void> _handleSuccess() async {
    // Check if user has preferences setup in Firestore
    final hasPrefs = await _dbService.checkPreferencesExist();

    // If prefs exist -> Home. If not -> Onboarding.
    final route = hasPrefs ? '/home' : '/preference';

    state = state.copyWith(
      isLoading: false,
      navigationRoute: route,
      error: null,
    );
  }

  Future<void> signInAnonymously() async {
    state = state.copyWith(isLoading: true, error: null, navigationRoute: null);
    try {
      await _auth.signInAnonymously();
      // Anonymous users usually need setup
      state = state.copyWith(isLoading: false, navigationRoute: '/home');
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state =
          state.copyWith(isLoading: false, error: 'An unknown error occurred.');
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null, navigationRoute: null);
    try {
      GoogleSignInAccount? googleUser;
      googleUser = await _googleSignIn.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);

      state = state.copyWith(isLoading: false, navigationRoute: null);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state =
          state.copyWith(isLoading: false, error: 'Google Sign-In Error: $e');
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      state = state.copyWith(error: 'Email and password cannot be empty.');
      return;
    }
    state = state.copyWith(isLoading: true, error: null, navigationRoute: null);

    try {
      // Try Login
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // ⬇️ Check Prefs
      await _handleSuccess();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
        try {
          // Auto-create account if not found
          await _auth.createUserWithEmailAndPassword(
              email: email, password: password);

          // New account -> Needs onboarding
          state =
              state.copyWith(isLoading: false, navigationRoute: '/preference');
        } on FirebaseAuthException catch (e2) {
          if (e2.code == 'email-already-in-use') {
            state = state.copyWith(
                isLoading: false,
                error:
                    'This email is linked to Google. Please use "Continue with Google".');
          } else {
            state = state.copyWith(isLoading: false, error: e2.message);
          }
        }
      } else {
        state = state.copyWith(isLoading: false, error: e.message);
      }
    } catch (e) {
      state = state.copyWith(
          isLoading: false,
          error: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<void> registerWithEmail(
      String email, String password, String username) async {
    if (email.isEmpty || password.isEmpty || username.isEmpty) {
      state = state.copyWith(error: 'All fields are required.');
      return;
    }

    state = state.copyWith(isLoading: true, error: null, navigationRoute: null);

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(username);
        await userCredential.user!.reload();
      }

      // Registration -> Needs onboarding
      state = state.copyWith(isLoading: false, navigationRoute: '/preference');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        state = state.copyWith(
            isLoading: false,
            error: 'This email is already registered. Please Login.');
      } else if (e.code == 'weak-password') {
        state = state.copyWith(
            isLoading: false, error: 'Password is too weak. Try a longer one.');
      } else {
        state = state.copyWith(isLoading: false, error: e.message);
      }
    } catch (e) {
      state =
          state.copyWith(isLoading: false, error: 'Registration failed: $e');
    }
  }
}

// --- PROVIDERS ---
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, LoginState>(
  (ref) => LoginViewModel(
    ref.watch(firebaseAuthProvider),
    ref.watch(userDatabaseServiceProvider),
  ),
);
