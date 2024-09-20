import 'package:app/components/text_input_field.dart';
import 'package:app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class AffineCipherScreen extends StatefulWidget {
  const AffineCipherScreen({super.key});

  @override
  State createState() => _AffineCipherScreenState();
}

class _AffineCipherScreenState extends State<AffineCipherScreen> {
  final messageController = TextEditingController();
  final keyOneController = TextEditingController();
  final keyTwoController = TextEditingController();
  String resultText = '';

  void encryptText() {
    setState(() {
      final text = messageController.text;
      final a = int.tryParse(keyOneController.text) ?? 0; // Multiplier
      final b = int.tryParse(keyTwoController.text) ?? 0; // Offset
      resultText = affineEncrypt(text, a, b);
    });
  }

  String affineEncrypt(String text, int a, int b) {
    // int aInverse = 0;
    // for (int i = 0; i < 26; i++) {
    //   if ((a * i) % 26 == 1) {
    //     aInverse = i;
    //     break;
    //   }
    // }
    String cipherText = '';
    for (int i = 0; i < text.length; i++) {
      String char = text[i];
      if (char.isNotEmpty) {
        if (RegExp(r'[A-Za-z]').hasMatch(char)) {
          char = char.toUpperCase();
          String cipherChar = String.fromCharCode(
              ((a * (char.codeUnitAt(0) - 65) + b) % 26) + 65);
          cipherText += cipherChar;
        } else {
          cipherText += char;
        }
      }
    }
    return cipherText;
  }

  void decryptText() {
    setState(() {
      final text = messageController.text;
      final a = int.tryParse(keyOneController.text) ?? 0; // Multiplier
      final b = int.tryParse(keyTwoController.text) ?? 0; // Offset
      resultText = affineDecrypt(text, a, b);
    });
  }

  String affineDecrypt(String cipherText, int a, int b) {
    int aInverse = 0;
    for (int i = 0; i < 26; i++) {
      if ((a * i) % 26 == 1) {
        aInverse = i;
        break;
      }
    }
    String plainText = '';
    for (int i = 0; i < cipherText.length; i++) {
      String char = cipherText[i];
      if (char.isNotEmpty) {
        if (RegExp(r'[A-Za-z]').hasMatch(char)) {
          char = char.toUpperCase();
          String plainChar = String.fromCharCode(
              (aInverse * (char.codeUnitAt(0) - b - 65) % 26) + 65);
          plainText += plainChar;
        } else {
          plainText += char;
        }
      }
    }
    return plainText;
  }

  void copyResult() {
    Clipboard.setData(ClipboardData(text: resultText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Result copied to clipboard')),
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    keyOneController.dispose();
    keyTwoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: CyberpunkColors.oxfordBlue,
      appBar: AppBar(
        title: const Text(
          'Affine Cipher',style: TextStyle(color: CyberpunkColors.fluorescentCyan),
        ),
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextInputField(publicKeyController: messageController, labelText: 'Enter Text'),
                  const SizedBox(height: 10),
                  TextInputField(publicKeyController: keyOneController, labelText: 'Enter 1st Key'),
                  const SizedBox(height: 10),
                  TextInputField(publicKeyController: keyTwoController, labelText: 'Enter 2nd Key'),
                  const SizedBox(height: 16.0),
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
                        child: Text('Result: $resultText',style:const TextStyle(color: CyberpunkColors.fluorescentCyan)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: copyResult,color: CyberpunkColors.fluorescentCyan,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}