import 'package:flutter/material.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final finalStyle = Theme.of(context).textTheme.headlineLarge;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('What', style: finalStyle),
        Text('should', style: finalStyle),
        Text('I cook?', style: finalStyle),
      ],
    );
  }
}
