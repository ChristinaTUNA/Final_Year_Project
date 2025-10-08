import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _goHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 32.0, vertical: 100.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              Image.asset(
                'assets/images/chef_mato.png',
                width: 80,
                height: 80,
              ),
              const SizedBox(height: 16),
              Text(
                'Sign Up or Log In',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => _goHome(context),
                  icon: const Icon(Icons.apple, color: Colors.white),
                  label: Text('Continue with Apple',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      )),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE02200),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('or',
                  style: GoogleFonts.poppins(color: const Color(0xFF6B7280))),
              const SizedBox(height: 16),
              Row(
                children: [
                  _SocialButton( icon: Image.asset(
                    'assets/images/Google.png',
                    width: 80,
                    height: 80,
                  ),)
                  const SizedBox(width: 16),
                  _SocialButton(
                      iicon: Image.asset(
                    'assets/images/Facebook.png',
                    width: 80,
                    height: 80,con: onTap: () => _goHome(context)),
                  const SizedBox(width: 16),
                  _SocialButton(
                      icon: Image.asset(
                    'assets/images/Email.png',
                    width: 80,
                    height: 80,icon:  onTap: () => _goHome(context)),
                ],
              ),
              const SizedBox(height: 24),
              Text.rich(
                TextSpan(
                  text: 'By logging in or registering, you agree to our ',
                  style: GoogleFonts.poppins(color: const Color(0xFF9CA3AF)),
                  children: [
                    TextSpan(
                      text: 'Terms of Service.',
                      style:
                          GoogleFonts.poppins(color: const Color(0xFF2563EB)),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _SocialButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF5F3),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: const Color(0xFF374151)),
        ),
      ),
    );
  }
}
