import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:equatable/equatable.dart';

// --- STATE ---
class LoginState extends Equatable {
  final bool isLoading;
  final String? error;
  final bool loginSuccess;

  const LoginState({
    this.isLoading = false,
    this.error,
    this.loginSuccess = false,
  });

  LoginState copyWith({
    bool? isLoading,
    String? error,
    bool? loginSuccess,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      loginSuccess: loginSuccess ?? this.loginSuccess,
    );
  }

  @override
  List<Object?> get props => [isLoading, error, loginSuccess];
}

// --- VIEWMODEL ---
class LoginViewModel extends StateNotifier<LoginState> {
  LoginViewModel(this._auth) : super(const LoginState()) {
    _initGoogleSignIn();
  }

  final FirebaseAuth _auth;

  // ⬇️ FIX 1: Use the Singleton instance (v7.x standard)
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  // ⬇️ FIX 2: Explicit Initialization
  void _initGoogleSignIn() {
    // The documentation says initialize must be called once.
    // We do it safely here. We don't await it in the constructor,
    // but it will be ready by the time the user clicks the button.
    _googleSignIn.initialize();
  }

  Future<void> signInAnonymously() async {
    state = state.copyWith(isLoading: true, error: null, loginSuccess: false);
    try {
      await _auth.signInAnonymously();
      state = state.copyWith(isLoading: false, loginSuccess: true);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state =
          state.copyWith(isLoading: false, error: 'An unknown error occurred.');
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null, loginSuccess: false);
    try {
      GoogleSignInAccount? googleUser;

      // 1. Trigger the authentication flow
      googleUser = await _googleSignIn.authenticate();

      // 2. Obtain the auth details
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // 3. Create a new credential for Firebase
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // 4. Sign in to Firebase
      await _auth.signInWithCredential(credential);

      state = state.copyWith(isLoading: false, loginSuccess: true);
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
    state = state.copyWith(isLoading: true, error: null, loginSuccess: false);

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      state = state.copyWith(isLoading: false, loginSuccess: true);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
        try {
          await _auth.createUserWithEmailAndPassword(
              email: email, password: password);
          state = state.copyWith(isLoading: false, loginSuccess: true);
        } on FirebaseAuthException catch (e2) {
          state = state.copyWith(
              isLoading: false, error: e2.message, loginSuccess: false);
        }
      } else {
        state = state.copyWith(
            isLoading: false, error: e.message, loginSuccess: false);
      }
    } catch (e) {
      state = state.copyWith(
          isLoading: false,
          error: 'An unexpected error occurred: ${e.toString()}',
          loginSuccess: false);
    }
  }
}

// --- PROVIDERS ---
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, LoginState>(
  (ref) => LoginViewModel(ref.watch(firebaseAuthProvider)),
);
