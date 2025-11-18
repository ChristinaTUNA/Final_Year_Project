import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  LoginViewModel(this._auth) : super(const LoginState());

  final FirebaseAuth _auth;

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null, loginSuccess: false);
    try {
      // 1. Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // User cancelled the flow
        state = state.copyWith(isLoading: false);
        return;
      }

      // 2. Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 3. Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Sign in to Firebase with the credential
      await _auth.signInWithCredential(credential);

      state = state.copyWith(isLoading: false, loginSuccess: true);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
          isLoading: false, error: 'Firebase Auth Error: ${e.message}');
    } catch (e) {
      state = state.copyWith(
          isLoading: false,
          error: 'An unexpected error occurred: ${e.toString()}',
          loginSuccess: false);
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      state = state.copyWith(error: 'Email and password cannot be empty.');
      return;
    }
    state = state.copyWith(isLoading: true, error: null, loginSuccess: false);

    try {
      // Try to sign in. If it fails because the user doesn't exist,
      // we'll catch it and create a new account. Other errors will be
      // caught by the general catch block.
      try {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          // If user doesn't exist, create a new account
          await _auth.createUserWithEmailAndPassword(
              email: email, password: password);
        } else {
          // Re-throw other auth errors (like wrong-password) to be caught below
          rethrow;
        }
      }
      // On success (either sign-in or sign-up), update the state
      state = state.copyWith(isLoading: false, loginSuccess: true);
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
          isLoading: false, error: 'Firebase Auth Error: ${e.message}');
    } catch (e) {
      state = state.copyWith(
          isLoading: false,
          error: 'An unexpected error occurred: ${e.toString()}');
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
