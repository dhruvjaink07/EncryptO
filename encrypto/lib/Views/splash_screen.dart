import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:app/Views/main_page.dart';
import 'package:app/Views/sign-in-up/sign_in.dart';
import 'package:app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Use a Timer to navigate after a delay
    Timer(
      const Duration(seconds: 4), // Set a delay for the splash screen
      () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userId = prefs.getString('id'); // Check if user ID exists

        // Navigate to the appropriate screen based on login state
        if (userId != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignIn()),
          );
        }
      },
    );

    return Scaffold(
      backgroundColor: CyberpunkColors.oxfordBlue,
      body: Center(
        child: AnimatedTextKit(
          repeatForever: true,
          animatedTexts: [
            FlickerAnimatedText(
              'Encrypto',
              textStyle: const TextStyle(
                  color: Colors.white, fontSize: 44, fontWeight: FontWeight.bold),
              speed: const Duration(milliseconds: 1200),
            ),
            FlickerAnimatedText(
              'Just make it',
              textStyle: const TextStyle(
                  color: Colors.white, fontSize: 44, fontWeight: FontWeight.bold),
              speed: const Duration(milliseconds: 1200),
            ),
          ],
        ),
      ),
    );
  }
}
