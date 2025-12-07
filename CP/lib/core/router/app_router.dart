import 'package:cookit/features/login/auth_landing_screen.dart';
import 'package:cookit/features/login/register_screen.dart';
import 'package:cookit/features/login/login_screen.dart';
import 'package:cookit/features/preference/edit_preferences_screen.dart';
import 'package:cookit/features/preference/preference_screen.dart';
import 'package:cookit/features/profile/about_screen.dart';
import 'package:cookit/features/profile/help_screen.dart';
import 'package:cookit/features/profile/profile_edit_screen.dart';

import 'package:cookit/features/profile/profile_favourite_screen.dart';
import 'package:cookit/features/recipe/recipe_screen.dart';
import 'package:cookit/features/scan/scan_screen.dart';
import 'package:cookit/features/shared/root_shell.dart';
import 'package:cookit/features/splash%20screen/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static const String initialRoute = '/';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
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
      case '/edit_profile':
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case '/edit_preferences':
        return MaterialPageRoute(builder: (_) => const MyPreferencesScreen());
      case '/my_favorites':
        return MaterialPageRoute(builder: (_) => const FavoritesScreen());
      case '/help':
        return MaterialPageRoute(builder: (_) => const HelpScreen());
      case '/about':
        return MaterialPageRoute(builder: (_) => const AboutScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('404 Page Not Found')),
          ),
        );
    }
  }
}
