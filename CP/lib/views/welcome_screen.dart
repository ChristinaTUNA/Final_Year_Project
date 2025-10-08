import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../viewmodels/welcome_viewmodel.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    // Transparent status bar
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    // Initialize ViewModel animations
    final viewModel = ref.read(welcomeViewModelProvider);
    viewModel.init(this);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(welcomeViewModelProvider);

    if (!viewModel.initialized) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFBF1C7),
      body: Stack(
        children: [
          // Large white circular shape at top-left
          Positioned(
            top: -200,
            right: 40,
            child: Container(
              width: 560,
              height: 560,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 35),
                  // Big headline
                  Text(
                    'What',
                    style: GoogleFonts.poppins(
                      fontSize: 68,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'should',
                    style: GoogleFonts.poppins(
                      fontSize: 68,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'I cook?',
                    style: GoogleFonts.poppins(
                      fontSize: 68,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(
                    flex: 3,
                  ),

                  // Mascot image with subtle bounce
                  ScaleTransition(
                    scale: viewModel.bounce,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Image.asset(
                        'assets/images/chef_mato_f.png',
                        width: 260,
                        height: 260,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: SizedBox(
          width: 180,
          height: 50,
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/onboarding'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE02200),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: Text(
              'Get Started',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
