import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'audio_player_screen.dart';
import 'calculator_screen.dart';
import 'cgpa_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget buildButton(
    BuildContext context,
    String text,
    IconData icon,
    Widget page,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 400),
            pageBuilder: (context, animation, secondaryAnimation) => page,
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppColors.gradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 15),
            Text(text, style: const TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(gradient: AppColors.gradient),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Student App",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            buildButton(
              context,
              "Calculator",
              Icons.calculate,
              const CalculatorScreen(),
            ),
            buildButton(context, "CGPA System", Icons.school, const CGPAScreen()),
            buildButton(
              context,
              "Audio Player",
              Icons.music_note,
              const AudioPlayerScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
