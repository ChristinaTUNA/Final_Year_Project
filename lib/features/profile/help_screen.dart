import 'package:cookit/core/theme/app_colors.dart';
import 'package:cookit/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const List<Map<String, String>> _faqs = [
    {
      'question': 'How do I scan ingredients?',
      'answer':
          'Tap the camera button in the center of the bottom bar. You can either take a photo or upload one from your gallery. Our AI will detect the ingredients for you.'
    },
    {
      'question': 'How does the "Cook Now" feature work?',
      'answer':
          'Cook Now suggests recipes based on the ingredients you currently have in your Pantry. The more items you add to your pantry, the better the suggestions!'
    },
    {
      'question': 'Can I change my dietary preferences?',
      'answer':
          'Yes! Go to Profile > My Preferences to update your diet (e.g., Vegan, Keto) and cooking time preferences.'
    },
    {
      'question': 'How do I save a recipe?',
      'answer':
          'When viewing a recipe, tap the bookmark icon in the top right corner. You can find all your saved recipes in Profile > My Favourites.'
    },
    {
      'question': 'Is the nutritional info accurate?',
      'answer':
          'We use standard nutritional data from Spoonacular. However, actual values may vary based on the specific brands or quantities you use.'
    },
  ];

  void _contactSupport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Support Email: support@cookit.com'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primary,
      ),
    );
  }

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
            ..._faqs.map((faq) => _buildFAQItem(
                  context,
                  faq['question']!,
                  faq['answer']!,
                )),
            const SizedBox(height: AppSpacing.xxl),
            Center(
              child: Column(
                children: [
                  Text(
                    "Still need help?",
                    style: textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () => _contactSupport(context),
                    icon: const Icon(Icons.mail_outline,
                        color: AppColors.primary),
                    label: const Text(
                      'Contact Support',
                      style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ],
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: AppColors.primary,
          collapsedIconColor: Colors.grey,
          title: Text(
            question,
            style: theme.textTheme.titleSmall,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                answer,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
