import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/features/login/auth_landing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'splash_viewmodel.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Staggered Animations
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _subtitleSlideAnimation;

  @override
  void initState() {
    super.initState();

    // Immersive Mode
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    // Controller Setup (Duration 2.5s for full effect)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // 1. Logo Pops In (0% -> 40%)
    _logoScaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.4, curve: Curves.elasticOut),
    );

    // 2. Title Fades In (30% -> 60%)
    _textFadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.6, curve: Curves.easeIn),
    );

    // 3. Subtitle Slides Up (50% -> 80%)
    _subtitleSlideAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 0.8, curve: Curves.easeOutQuad),
    );

    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage('assets/images/onboarding_1.webp'), context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the splash timer provider
    final isDone = ref.watch(splashProvider);

    if (isDone) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const AuthLandingScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      });
    }

    return Scaffold(
      // Subtle gradient background for premium feel
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.white, Color(0xFFFAFAFA)],
            center: Alignment.center,
            radius: 1.5,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // --- 1. Animated Logo ---
              ScaleTransition(
                scale: _logoScaleAnimation,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        blurRadius: 30,
                        spreadRadius: 5,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/chef_mato.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // --- 2. App Name ---
              FadeTransition(
                opacity: _textFadeAnimation,
                child: Text(
                  'COOKIT',
                  style: GoogleFonts.lilitaOne(
                    fontSize: 56,
                    color: AppColors.primary,
                    letterSpacing: 2.0,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // --- 3. Tagline ---
              SlideTransition(
                position: _subtitleSlideAnimation.drive(
                  Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero),
                ),
                child: FadeTransition(
                  opacity: _subtitleSlideAnimation,
                  child: Text(
                    'Your Smart Grocery Assistant',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // --- 4. Custom Loader (Bottom) ---
              // Shows active loading state
              FadeTransition(
                opacity: _subtitleSlideAnimation, // Fade in last
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    color: AppColors.primary.withValues(alpha: 0.5),
                    strokeWidth: 3,
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
