import 'package:app/Views/affine_cipher.dart';
import 'package:app/Views/animations/glitch.dart';
import 'package:app/Views/caeser_cipher.dart';
import 'package:app/Views/playfair_cipher.dart';
import 'package:app/Views/text_input_screen.dart';
import 'package:app/rsa/pages/home_page.dart';
import 'package:app/utils/colors.dart';
import 'package:flutter/material.dart';

class EncrytionPage extends StatelessWidget {
  const EncrytionPage({super.key});

  @override
  Widget build(BuildContext context) {
      double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: CyberpunkColors.oxfordBlue, // Use Oxford Blue as background
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //        Image.asset(
            //   'assets/hero.gif',
            //   height: screenHeight / 3,  // Adjust size as needed
            //   fit: BoxFit.contain,       // Ensure it fits within its constraints
            // ),
            const GlitchText(
              text: 'ENCRYPTO',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Keeping white color for text
              ),
            ),
            SizedBox(
                width: screenWidth / 2.5,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePageRsa()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CyberpunkColors.hollywoodCerise, // Hollywood Cerise for buttons
                    ),
                    child: const Text(
                      "RSA",
                      style: TextStyle(
                        color: CyberpunkColors.fluorescentCyan, // Fluorescent Cyan for button text
                      ),
                    ))),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
                width: screenWidth / 2.5,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const CaesarCipherScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CyberpunkColors.hollywoodCerise,
                    ),
                    child: const Text(
                      "Caeser Cipher",
                      style: TextStyle(color: CyberpunkColors.fluorescentCyan),
                    ))),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
                width: screenWidth / 2.5,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AffineCipherScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CyberpunkColors.hollywoodCerise,
                    ),
                    child: const Text(
                      "Affine Cipher",
                      style: TextStyle(color: CyberpunkColors.fluorescentCyan),
                    ))),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
                width: screenWidth / 2.5,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PlayfairCipherScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CyberpunkColors.hollywoodCerise,
                    ),
                    child: const Text(
                      "Playfair Cipher",
                      style: TextStyle(color: CyberpunkColors.fluorescentCyan),
                    ))),
          ],
        ),
      ),
    );
  }
}