import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('What',
            style: GoogleFonts.poppins(
              fontSize: 68,
              fontWeight: FontWeight.w700,
              height: 1.15,
              color: Colors.black,
            )),
        Text('should',
            style: GoogleFonts.poppins(
              fontSize: 68,
              fontWeight: FontWeight.w700,
              height: 1.15,
              color: Colors.black,
            )),
        Text('I cook?',
            style: GoogleFonts.poppins(
              fontSize: 68,
              fontWeight: FontWeight.w700,
              height: 1.15,
              color: Colors.black,
            )),
      ],
    );
  }
}
