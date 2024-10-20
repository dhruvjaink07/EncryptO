import 'dart:io';

import 'package:app/components/text_input_field.dart';
import 'package:app/services/emailService.dart';
import 'package:app/utils/colors.dart';
import 'package:app/utils/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';


class AffineCipherScreen extends StatefulWidget {
  const AffineCipherScreen({super.key});

  @override
  State createState() => _AffineCipherScreenState();
}

class _AffineCipherScreenState extends State<AffineCipherScreen> {
  final messageController = TextEditingController();
  final keyOneController = TextEditingController();
  final keyTwoController = TextEditingController();
  final phoneController = TextEditingController();
  String recipientEmail = '';
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

Future<void> pickAndEncryptFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['txt']);
  if (result != null) {
    File file = File(result.files.single.path!);
    String content = await file.readAsString();
    int key = int.tryParse(keyOneController.text) ?? 5;
    int key2 = int.tryParse(keyTwoController.text) ?? 7;
    String encryptedText = affineEncrypt(content, key, key2);

    // Get the Downloads directory path
    Directory? downloadsDirectory = Directory(Api.directoryPath);

    // Save encrypted file in the Downloads directory 
    if (downloadsDirectory.existsSync()) {
      String newPath = '${downloadsDirectory.path}/affine_encrypted_demo.txt';
      File encryptedFile = File(newPath);
      await encryptedFile.writeAsString(encryptedText);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File encrypted and saved at $newPath')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to access Downloads directory')),
      );
    }
  }
}

Future<void> pickAndDecryptFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['txt']);
  if (result != null) {
    File file = File(result.files.single.path!);
    String content = await file.readAsString();
    int key = int.tryParse(keyOneController.text) ?? 5;
    int key2 = int.tryParse(keyTwoController.text) ?? 7;
    String decryptedText = affineDecrypt(content, key, key2);

    // Get the Downloads directory path
    Directory? downloadsDirectory = Directory(Api.directoryPath);

    // Save decrypted file in the Downloads directory
    if (downloadsDirectory.existsSync()) {
      String newPath = '${downloadsDirectory.path}/affine_decrypted_demo.txt';
      File decryptedFile = File(newPath);
      await decryptedFile.writeAsString(decryptedText);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File decrypted and saved at $newPath')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to access Downloads directory')),
      );
    }
  }
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
                    EmailService().sendAFEmail(recipientEmail, resultText, "Affine Cipher", keyOneController.text.trim(), keyTwoController.text.trim()); // Call email sending function
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
// Add these methods to your _CaesarCipherScreenState class

  launchWhatsAppUri(String phoneNumber) async {
    final link = WhatsAppUnilink(
      phoneNumber: phoneNumber,
      text: "Message $resultText : To Decrypt : Keys are - ${keyOneController.text} and ${keyTwoController.text} as of Affine Cipher",
    );
    // Correctly convert to Uri using toString()
    final uri = Uri.parse(link.toString());

    try {
      await launchUrl(uri);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to launch WhatsApp')),
      );
    }
  }

  void showPhoneNumberDialog() {
    String phoneNumber = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: CyberpunkColors.oxfordBlue,
          title: const Text(
            'Enter Phone Number',
            style: TextStyle(color: CyberpunkColors.fluorescentCyan),
          ),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0, vertical: 8.0), // Reduced padding

          content: TextInputField(
              publicKeyController: phoneController,
              labelText: 'Phone Number (with country code)'),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: CyberpunkColors.darkViolet),
              ),
              onPressed: () {
                phoneController.clear();
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text(
                'Send',
                style: TextStyle(color: CyberpunkColors.darkViolet),
              ),
              onPressed: () {
                if (phoneController.text.isNotEmpty) {
                  Navigator.of(context).pop(); // Close the dialog
                  phoneNumber = phoneController.text;
                  launchWhatsAppUri(
                      phoneNumber); // Launch WhatsApp with the entered phone number
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please enter a valid phone number')),
                  );
                }
                phoneController.clear();
              },
            ),
          ],
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
        actions: [
              IconButton(
            onPressed: () {
              setState(() {
                messageController.clear();
                keyOneController.clear();
                keyTwoController.clear();
                phoneController.clear();
                resultText = '';
              });
            },
            icon: const Icon(
              Icons.refresh_outlined,
              color: CyberpunkColors.fluorescentCyan,
            ),
          ),
  ],
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                    const Text('Share on: ',style: TextStyle(color: Colors.white),),
                    IconButton(
                        icon: const Icon(Icons.mail_outline_outlined, color: CyberpunkColors.fluorescentCyan,),
                        onPressed: showEmailBottomSheet),
                    IconButton(onPressed: showPhoneNumberDialog, icon: const FaIcon(FontAwesomeIcons.whatsapp, color: CyberpunkColors.fluorescentCyan,))
                  ]),
                  ElevatedButton(
                    onPressed: pickAndEncryptFile,
                    style: ElevatedButton.styleFrom(
                  backgroundColor: CyberpunkColors.hollywoodCerise,
                ),
                child: const Text(
                  'Encrypt File',
                  style: TextStyle(color: CyberpunkColors.fluorescentCyan),
                ),),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: pickAndDecryptFile,
                    style: ElevatedButton.styleFrom(
                  backgroundColor: CyberpunkColors.hollywoodCerise,
                ),
                child: const Text(
                  'Decrypt File',
                  style: TextStyle(color: CyberpunkColors.fluorescentCyan),
                ),),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}