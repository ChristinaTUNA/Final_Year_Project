import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'widgets/welcome_body.dart';
import 'widgets/welcome_header.dart';
import 'widgets/welcome_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bounceController;
  late final Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticInOut),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF1C7),
      body: Stack(
        children: [
          // Top-left big white circle
          Positioned(
            top: -180,
            right: 40,
            child: Container(
              width: 560,
              height: 560,
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Header top-left
          const Positioned(
            top: AppSpacing.xxl,
            left: AppSpacing.xl,
            child: WelcomeHeader(),
          ),
          // Body center-right
          const Positioned(
            bottom: 220,
            right: AppSpacing.xl,
            child: WelcomeBody(),
          ),
          // Button bottom-center
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: WelcomeButton(
                animation: _bounceAnimation,
                onPressed: () {
                  Navigator.pushNamed(context, '/intro');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Assuming WelcomeButton looks something like this, we update it.
// This file is not in context, but this shows how to adapt it.
/*
--- a/lib/views/welcome/widgets/welcome_button.dart
+++ b/lib/views/welcome/widgets/welcome_button.dart
@@ -1,13 +1,13 @@
 import 'package:flutter/material.dart';
 
 class WelcomeButton extends StatelessWidget {
-  final WelcomeViewModel viewModel;
+  final Animation<double> animation;
   final VoidCallback onPressed;
 
   const WelcomeButton({
     super.key,
-    required this.viewModel,
+    required this.animation,
     required this.onPressed,
   });
 
@@ -16,7 +16,7 @@
   Widget build(BuildContext context) {
     return ScaleTransition(
-      scale: viewModel.bounceAnimation,
+      scale: animation,
       child: ElevatedButton(
         onPressed: onPressed,
         // ... rest of the button code
*/
