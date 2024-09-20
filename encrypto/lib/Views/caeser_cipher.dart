import 'package:app/components/text_input_field.dart';
import 'package:app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CaesarCipherScreen extends StatefulWidget {
  const CaesarCipherScreen({super.key});

  @override
  State createState() => _CaesarCipherScreenState();
}

class _CaesarCipherScreenState extends State<CaesarCipherScreen> {
  final messageController = TextEditingController();
  final shiftController = TextEditingController();
  String resultText = '';

  void encryptText() {
    setState(() {
      final text = messageController.text;
      final shift = int.tryParse(shiftController.text) ?? 0;

      resultText = caesarCipher(text, shift);
    });
  }

  String caesarCipher(String text, int shift) {
    String cipherText = '';
    for (int i = 0; i < text.length; i++) {
      String char = text[i];
      if (char.isNotEmpty) {
        if (RegExp(r'[A-Za-z]').hasMatch(char)) {
          char = char.toUpperCase();
          String cipherChar =
              String.fromCharCode((char.codeUnitAt(0) - 65 + shift) % 26 + 65);
          cipherText += cipherChar;
        } else {
          cipherText += char;
        }
      }
    }

    return cipherText;
  }

  void decryptText() {
    // Implement the Caesar cipher decryption logic
    final text = messageController.text;
    final shift = int.tryParse(shiftController.text) ?? 0; // Shift value

    String plainText = '';
    for (int i = 0; i < text.length; i++) {
      String char = text[i];
      if (RegExp(r'[A-Za-z]').hasMatch(char)) {
        String char = text[i].toUpperCase();
        String plainChar =
            String.fromCharCode((char.codeUnitAt(0) - 65 - shift) % 26 + 65);
        plainText += plainChar;
      } else {
        plainText += text[i];
      }
    }
    setState(() {
      resultText = plainText;
    });
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void copyResult() {
    Clipboard.setData(ClipboardData(text: resultText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Text copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: CyberpunkColors.oxfordBlue,
      appBar: AppBar(
        title: const Text('Caeser Cipher',style: TextStyle(color: CyberpunkColors.fluorescentCyan),),
        backgroundColor: CyberpunkColors.darkViolet, // Cyberpunk theme for AppBar
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: CyberpunkColors.fluorescentCyan, // Icon color from Cyberpunk theme
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                TextInputField(publicKeyController: messageController, labelText: 'Enter Text'),
                const SizedBox(height: 10),
                TextInputField(publicKeyController: shiftController, labelText: 'Enter Shift'),
                const SizedBox(height: 35),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    SizedBox(
            width: screenWidth / 2.5,
            child: ElevatedButton(
              onPressed: encryptText,
              style: ElevatedButton.styleFrom(
                backgroundColor: CyberpunkColors.hollywoodCerise, // Button color
              ),
              child: const Text(
                "Encrypt",
                style: TextStyle(
                  color: CyberpunkColors.fluorescentCyan,
                  fontSize: 18,
                ),
              ),
            ),
          ),
                    const SizedBox(width: 16.0),
                    SizedBox(
            width: screenWidth / 2.5,
            child: ElevatedButton(
              onPressed: decryptText,
              style: ElevatedButton.styleFrom(
                backgroundColor: CyberpunkColors.hollywoodCerise, // Button color
              ),
              child: const Text(
                "Decrypt",
                style: TextStyle(
                  color: CyberpunkColors.fluorescentCyan,
                  fontSize: 18,
                ),
              ),
            ),
          ),
                    ],
                  ),
                const SizedBox(height: 16.0),
                Row(
                    children: [
                      Expanded(
                        child: Text('Result: $resultText',style: TextStyle(color: Colors.white),),
                      ),
                      IconButton(
                      icon: const Icon(Icons.copy,color: CyberpunkColors.fluorescentCyan,),
                      onPressed: copyResult,
                      ),
                    ],
                  ),
                ],

            ),
          ),
        ),
      ),
    );
  }
}