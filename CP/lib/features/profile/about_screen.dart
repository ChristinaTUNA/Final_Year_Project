import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: AppSpacing.pAllLg,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: .1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons
                      .restaurant_menu, // Or use Image.asset('assets/images/logo.png')
                  size: 50,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // 2. App Name & Version
              Text('CooKit', style: textTheme.displayMedium),
              const SizedBox(height: 8),
              Text(
                'Version 1.0.0',
                style:
                    textTheme.bodyMedium?.copyWith(color: AppColors.textGray),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // 3. Description
              Text(
                'CooKit is your smart kitchen assistant. Scan ingredients, minimize food waste, and discover delicious recipes tailored just for you.',
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge,
              ),

              const Spacer(),

              // 4. Footer / Credits
              Text(
                'Developed for Final Year Project',
                style: textTheme.bodySmall
                    ?.copyWith(color: AppColors.textLightGray),
              ),
              const SizedBox(height: 4),
              Text(
                '© 2024 CooKit Team',
                style: textTheme.bodySmall
                    ?.copyWith(color: AppColors.textLightGray),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
