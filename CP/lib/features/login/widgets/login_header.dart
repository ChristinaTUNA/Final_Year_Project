import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.displayMedium;

    return Column(
      children: [
        Image.asset(
          'assets/images/chef_mato.png',
          width: 80,
          height: 80,
        ),
        const SizedBox(height: 16),
        Text(
          'Sign Up or Log In',
          style: titleStyle,
        ),
      ],
    );
  }
}
