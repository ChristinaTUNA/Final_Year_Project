import 'package:cookit/features/login/register_screen.dart';
import 'package:cookit/features/login/login_screen.dart';
import 'package:cookit/features/recipe/recipe_screen.dart';
import 'package:cookit/features/scan/scan_screen.dart';
import 'package:flutter/material.dart';
import '../../features/splash screen/splash_screen.dart';
// import '../../features/welcome/welcome_screen.dart';
// import '../../features/intro/intro_screen.dart';
import '../../features/login/auth_landing_screen.dart';
import '../../features/shared/root_shell.dart';
import '../../features/preference/preference_screen.dart';

class AppRouter {
  static const String initialRoute = '/';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      // case '/welcome':
      //   return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      // case '/intro':
      //   return MaterialPageRoute(builder: (_) => const IntroScreen());
      case '/auth_landing':
        return MaterialPageRoute(builder: (_) => const AuthLandingScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case '/preference':
        return MaterialPageRoute(builder: (_) => const PreferenceScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const RootShell());
      case '/recipe':
        final recipeId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => RecipeScreen(recipeId: recipeId),
        );
      case '/scan':
        return MaterialPageRoute(builder: (_) => const ScanScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('404 Page Not Found')),
          ),
        );
    }
  }
}
