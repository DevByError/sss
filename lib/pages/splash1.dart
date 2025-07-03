import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/signin_page.dart'; // Import SignInPage

class SplashScreen extends StatefulWidget {
  final void Function(Locale) onLocaleChange;

  const SplashScreen({super.key, required this.onLocaleChange});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _exitController;

  late Animation<double> _scaleAnimation;
  late Animation<Offset> _logoEntrySlide;
  late Animation<Offset> _logoExitSlide;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _exitController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 8.0, end: 10.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeInOut),
    );

    _logoEntrySlide = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: _entryController, curve: Curves.easeOut));

    _logoExitSlide = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0),
    ).animate(CurvedAnimation(parent: _exitController, curve: Curves.easeIn));

    _startAnimations();
  }

  void _startAnimations() async {
    await _entryController.forward(); // Start the entry animation

    // Wait for 3 seconds to show the splash screen and animation
    await Future.delayed(const Duration(seconds: 3));

    await _exitController.forward(); // Start the exit animation

    // After the animation is completed, navigate to the SignInPage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()),
    );
  }

  @override
  void dispose() {
    _entryController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF43D33), // Cherry red
              Color(0xFF160201), // Dark red
            ],
          ),
        ),
        width: double.infinity, // Make sure the container covers full width
        height: double.infinity, // Make sure the container covers full height
        child: Center(
          child: AnimatedBuilder(
            animation: Listenable.merge([_entryController, _exitController]),
            builder: (context, child) {
              return SlideTransition(
                position: _logoExitSlide,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Image.asset(
                    'assets/luc_logo.png', // Path to your logo
                    height: 180,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
