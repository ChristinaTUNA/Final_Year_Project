import 'package:flutter/material.dart';
import 'views/splash_screen.dart';
import 'views/welcome_screen.dart';
import 'views/onboarding/onboarding_screen.dart';
import 'views/login_screen.dart';
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
      // case '/login':
      //   return MaterialPageRoute(builder: (_) => const LoginScreen());
      // case '/home':
      //   return MaterialPageRoute(builder: (_) => const RootShell());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('404 Page Not Found')),
          ),
        );
    }
  }
}
