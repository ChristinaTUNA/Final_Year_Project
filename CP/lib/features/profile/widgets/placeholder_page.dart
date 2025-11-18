//lib/features/profile/widgets/placeholder_page.dart
import 'package:flutter/material.dart';

class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child:
            Text(title, style: textTheme.displayMedium?.copyWith(fontSize: 18)),
      ),
    );
  }
}
