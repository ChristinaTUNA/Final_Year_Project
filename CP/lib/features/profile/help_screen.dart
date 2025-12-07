import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.pHorizontalLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.md),
            Text(
              'Frequently Asked Questions',
              style: textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.lg),

            // --- FAQs ---
            _buildFAQItem(
              context,
              'How do I scan ingredients?',
              'Tap the camera button in the center of the bottom bar. You can either take a photo or upload one from your gallery. Our AI will detect the ingredients for you.',
            ),
            _buildFAQItem(
              context,
              'How does the "Cook Now" feature work?',
              'Cook Now suggests recipes based on the ingredients you currently have in your Pantry. The more items you add to your pantry, the better the suggestions!',
            ),
            _buildFAQItem(
              context,
              'Can I change my dietary preferences?',
              'Yes! Go to Profile > My Preferences to update your diet (e.g., Vegan, Keto) and cooking time preferences.',
            ),
            _buildFAQItem(
              context,
              'How do I save a recipe?',
              'When viewing a recipe, tap the bookmark icon in the top right corner. You can find all your saved recipes in Profile > My Favourites.',
            ),
            _buildFAQItem(
              context,
              'Is the nutritional info accurate?',
              'We use standard nutritional data from Spoonacular. However, actual values may vary based on the specific brands or quantities you use.',
            ),

            const SizedBox(height: AppSpacing.xxl),

            // --- Contact Support Stub ---
            Center(
              child: TextButton.icon(
                onPressed: () {
                  // TODO: Implement email launch
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Contact feature coming soon!')),
                  );
                },
                icon: const Icon(Icons.mail_outline, color: AppColors.primary),
                label: const Text(
                  'Contact Support',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(BuildContext context, String question, String answer) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textGray,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
