import 'package:app/components/text_input_field.dart';
import 'package:app/services/emailService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/utils/colors.dart'; // Assuming you have your custom Cyberpunk colors
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart'; // For sending emails

class CaesarCipherScreen extends StatefulWidget {
  const CaesarCipherScreen({super.key});

  @override
  State createState() => _CaesarCipherScreenState();
}

class _CaesarCipherScreenState extends State<CaesarCipherScreen> {
  final messageController = TextEditingController();
  final shiftController = TextEditingController();
  String resultText = '';
  String recipientEmail = ''; // Stores the recipient's email

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
    final text = messageController.text;
    final shift = int.tryParse(shiftController.text) ?? 0;

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

void showEmailBottomSheet() {
  showModalBottomSheet(
    context: context,
    backgroundColor: CyberpunkColors.darkViolet,
    isScrollControlled: true, // Allows the bottom sheet to adjust height when the keyboard appears
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust padding based on keyboard
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Enter Receiver\'s Email',
                  style: TextStyle(fontSize: 18, color: CyberpunkColors.fluorescentCyan),
                ),
                const SizedBox(height: 10),
                TextField(
                  cursorColor: CyberpunkColors.fluorescentCyan,
                  decoration: const InputDecoration(
                    labelText: 'Receiver Email',
                    labelStyle: TextStyle(color: Colors.white),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: CyberpunkColors.fluorescentCyan),
                    ),
                  ),
                  style: const TextStyle(color: CyberpunkColors.fluorescentCyan),
                  onChanged: (value) {
                    recipientEmail = value;
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus(); // Remove focus to prevent keyboard from showing
                    Navigator.pop(context); // Close the bottom sheet
                    EmailService().sendCCEmail(recipientEmail, resultText, "Caeser Cipher", shiftController.text.trim()); // Call email sending function
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CyberpunkColors.hollywoodCerise,
                  ),
                  child: const Text(
                    'Send Email',
                    style: TextStyle(color: CyberpunkColors.fluorescentCyan),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: CyberpunkColors.oxfordBlue,
      appBar: AppBar(
        title: const Text(
          'Caeser Cipher',
          style: TextStyle(color: CyberpunkColors.fluorescentCyan),
        ),
        backgroundColor: CyberpunkColors.darkViolet,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: CyberpunkColors.fluorescentCyan,
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
                            backgroundColor: CyberpunkColors.hollywoodCerise,
                          ),
                          child: const Text(
                            'Encrypt',
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
                            backgroundColor: CyberpunkColors.hollywoodCerise,
                          ),
                          child: const Text(
                            'Decrypt',
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
                        child: Text(
                          'Result: $resultText',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.copy,
                          color: CyberpunkColors.fluorescentCyan,
                        ),
                        onPressed: copyResult,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: showEmailBottomSheet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CyberpunkColors.hollywoodCerise,
                    ),
                    child: const Text(
                      'Share via Email',
                      style: TextStyle(color: CyberpunkColors.fluorescentCyan),
                    ),
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
