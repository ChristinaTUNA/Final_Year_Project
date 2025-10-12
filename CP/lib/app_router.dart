// import 'views/recipe_screen.dart';
import 'package:flutter/material.dart';
import 'views/splash_screen.dart';
import 'views/welcome/welcome_screen.dart';
import 'views/onboarding/onboarding_screen.dart';
import 'views/login/login_screen.dart';
import 'views/root_shell.dart';

class AppRouter {
  static const String initialRoute = '/';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/welcome':
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const RootShell());
      // case '/recipe':
      //   return MaterialPageRoute(builder: (_) => const RecipeScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('404 Page Not Found')),
          ),
        );
    }
  }
}
