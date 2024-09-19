import "package:app/Views/animations/glitch.dart";
import "package:app/Views/text_input_screen.dart";
import "package:app/utils/colors.dart";
import "package:flutter/material.dart";

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const GlitchText(
              text: 'ENCRYPTO',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(
                width: screenWidth / 2.5,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TextInputScreen(
                                    pageName: "RSA",
                                    labelText: "Enter Message",
                                    nextPage: TextInputScreen(
                                        pageName: "Enter Receiver's public key",
                                        labelText: "Enter public key"),
                                  )));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.highlightEffect,
                    ),
                    child: const Text(
                      "RSA",
                      style: TextStyle(
                        color: AppColors.textPrimary,
                      ),
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
                              builder: (context) => const TextInputScreen(
                                    pageName: "Caeser Cipher",
                                    labelText: "Enter Message",
                                  )));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.highlightEffect,
                    ),
                    child: const Text(
                      "Caeser Cipher",
                      style: TextStyle(color: AppColors.textPrimary),
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
                              builder: (context) => const TextInputScreen(
                                    pageName: "Affine Cipher",
                                    labelText: "Enter Message",
                                    // nextPage: TextInputScreen(
                                    //     pageName: "Enter Receiver's public key",
                                    //     labelText: "Enter public key"),
                                  )));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.highlightEffect,
                    ),
                    child: const Text(
                      "Affine Cipher",
                      style: TextStyle(color: AppColors.textPrimary),
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
                              builder: (context) => const TextInputScreen(
                                    pageName: "Playfair Cipher",
                                    labelText: "Enter Message",
                                    // nextPage: TextInputScreen(
                                    //     pageName: "Enter Receiver's public key",
                                    //     labelText: "Enter public key"),
                                  )));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.highlightEffect,
                    ),
                    child: const Text(
                      "Playfair Cipher",
                      style: TextStyle(color: AppColors.textPrimary),
                    ))),
          ],
        ),
      ),
    );
  }
}
