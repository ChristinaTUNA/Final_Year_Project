import 'package:flutter/material.dart';

class WelcomeBody extends StatelessWidget {
  const WelcomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/chef_mato_f.png',
      width: 260,
      height: 260,
      fit: BoxFit.contain,
    );
  }
}
