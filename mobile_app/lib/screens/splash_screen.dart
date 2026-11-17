import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    print("SplashScreen: initState");
    _navigateToHome();
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    print("SplashScreen: Navigating to MainScreen");
    try {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } catch (e) {
      print("SplashScreen Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'MINISHOP',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
            ),
          ],
        ),
      ),
    );
  }
}
