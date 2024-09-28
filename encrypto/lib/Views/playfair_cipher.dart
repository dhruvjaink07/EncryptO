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

class PlayfairCipherScreen extends StatefulWidget {
  const PlayfairCipherScreen({super.key});

  @override
  State createState() => _PlayfairCipherScreenState();
}

class _PlayfairCipherScreenState extends State<PlayfairCipherScreen> {
  final textController = TextEditingController();
  final keyController = TextEditingController();
  final phoneController = TextEditingController();
  String resultText = '';
  String recipientEmail = '';

  void encryptText(String uKey) {
    final text = textController.text.toUpperCase();
    final key = uKey;
    String cipherText = playfairEncrypt(text, key);
    setState(() {
      resultText = cipherText;
    });
  }

  String playfairEncrypt(String text, String key) {
    text = text.replaceAll(RegExp(r'[^A-Z]'), '').toUpperCase();
    key = key.replaceAll(RegExp(r'[^A-Z]'), '').toUpperCase();

    String alphabet = 'ABCDEFGHIKLMNOPQRSTUVWXYZ';
    String matrix = key + alphabet;
    matrix = matrix.replaceAll(RegExp(r'J'), '');
    matrix = matrix.split('').toSet().toList().join();
    matrix = matrix.padRight(25, 'X');
    List<List<String>> playfairMatrix =
        List.generate(5, (i) => List.generate(5, (j) => matrix[i * 5 + j]));

    String cipherText = '';
    for (int i = 0; i < text.length; i += 2) {
      String a = text[i];
      String b = i + 1 < text.length ? text[i + 1] : 'X';

      int? aRow, aCol, bRow, bCol;
      for (int r = 0; r < 5; r++) {
        for (int c = 0; c < 5; c++) {
          if (playfairMatrix[r][c] == a) {
            aRow = r;
            aCol = c;
          }
          if (playfairMatrix[r][c] == b) {
            bRow = r;
            bCol = c;
          }
        }
      }

      aRow ??= 0;
      aCol ??= 0;
      bRow ??= 0;
      bCol ??= 0;

      if (aRow == bRow) {
        cipherText += playfairMatrix[aRow][(aCol + 1) % 5];
        cipherText += playfairMatrix[bRow][(bCol + 1) % 5];
      } else if (aCol == bCol) {
        cipherText += playfairMatrix[(aRow + 1) % 5][aCol];
        cipherText += playfairMatrix[(bRow + 1) % 5][bCol];
      } else {
        cipherText += playfairMatrix[aRow][bCol];
        cipherText += playfairMatrix[bRow][aCol];
      }
    }
    return cipherText;
  }

  void decryptText(String uKey) {
    final text = textController.text.toUpperCase();
    final key = uKey;
    String plainText = playfairDecrypt(text, key);
    setState(() {
      resultText = plainText;
    });
  }

  String playfairDecrypt(String text, String key) {
    text = text.replaceAll(RegExp(r'[^A-Z]'), '').toUpperCase();
    key = key.replaceAll(RegExp(r'[^A-Z]'), '').toUpperCase();

    String alphabet = 'ABCDEFGHIKLMNOPQRSTUVWXYZ';
    String matrix = key + alphabet;
    matrix = matrix.replaceAll(RegExp(r'J'), '');
    matrix = matrix.split('').toSet().toList().join();
    matrix = matrix.padRight(25, 'X');
    List<List<String>> playfairMatrix =
        List.generate(5, (i) => List.generate(5, (j) => matrix[i * 5 + j]));

    String plainText = '';
    for (int i = 0; i < text.length; i += 2) {
      String a = text[i];
      String b = i + 1 < text.length ? text[i + 1] : 'X';

      int aRow = 0, aCol = 0, bRow = 0, bCol = 0;
      for (int r = 0; r < 5; r++) {
        for (int c = 0; c < 5; c++) {
          if (playfairMatrix[r][c] == a) {
            aRow = r;
            aCol = c;
          }
          if (playfairMatrix[r][c] == b) {
            bRow = r;
            bCol = c;
          }
        }
      }

      if (aRow == bRow) {
        plainText += playfairMatrix[aRow][(aCol + 4) % 5];
        plainText += playfairMatrix[bRow][(bCol + 4) % 5];
      } else if (aCol == bCol) {
        plainText += playfairMatrix[(aRow + 4) % 5][aCol];
        plainText += playfairMatrix[(bRow + 4) % 5][bCol];
      } else {
        plainText += playfairMatrix[aRow][bCol];
        plainText += playfairMatrix[bRow][aCol];
      }
    }

    if (plainText.endsWith('X') && text.length % 2 == 0) {
      plainText = plainText.substring(0, plainText.length - 1);
    }

    return plainText;
  }

  Future<void> pickAndEncryptFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['txt']);
    if (result != null) {
      File file = File(result.files.single.path!);
      String content = await file.readAsString();
      String key = keyController.text.isNotEmpty ? keyController.text : "Inevitable";
      String encryptedText = playfairEncrypt(content, key);

      Directory? downloadsDirectory = Directory(Api.directoryPath);

      if (downloadsDirectory.existsSync()) {
        String newPath = '${downloadsDirectory.path}/playfair_encrypted_demo.txt';
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
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['txt']);
    if (result != null) {
      File file = File(result.files.single.path!);
      String content = await file.readAsString();
      String key = keyController.text.isNotEmpty ? keyController.text : "Inevitable";
      String decryptedText = playfairDecrypt(content, key);

      Directory? downloadsDirectory = Directory(Api.directoryPath);

      if (downloadsDirectory.existsSync()) {
        String newPath = '${downloadsDirectory.path}/playfair_decrypted_demo.txt';
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

  void showEmailBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: CyberpunkColors.darkViolet,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
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
                    EmailService().sendPFEmail(recipientEmail, resultText, "Playfair Cipher",keyController.text.trim()); // Call email sending function
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CyberpunkColors.hollywoodCerise,
                    ),
                    child: const Text('Send Email', style: TextStyle(color: Colors.white)),
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
      text: "Message $resultText : To Decrypt : Key is - ${keyController.text} as of Playfair Cipher",
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
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: CyberpunkColors.oxfordBlue,
      appBar: AppBar(
        backgroundColor: CyberpunkColors.darkViolet,
        title: const Text('Playfair Cipher', style: TextStyle(color: CyberpunkColors.fluorescentCyan)),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                textController.clear();
                keyController.clear();
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
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Playfair Cipher',
                style: TextStyle(fontSize: 24, color: CyberpunkColors.fluorescentCyan),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextInputField(
                publicKeyController: textController,
                labelText: 'Enter Text',
              ),
              const SizedBox(height: 10),
              TextInputField(
                publicKeyController: keyController,
                labelText: 'Enter Key',
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const SizedBox(width: 16.0),
                       SizedBox(
                width: screenWidth / 2.5,
                child: ElevatedButton(
                  onPressed:(){
                    encryptText(keyController.text);
                  },
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
                ),),
                    const SizedBox(width: 16.0),
                       SizedBox(
                width: screenWidth / 2.5,
                child: ElevatedButton(
                  onPressed:(){
                    decryptText(keyController.text);
                  },
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
                ),)
        
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: pickAndEncryptFile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: CyberpunkColors.hollywoodCerise,
                ),
                child: const Text(
                  'Encrypt File',
                  style: TextStyle(color: CyberpunkColors.fluorescentCyan),
                ),
              ),
              ElevatedButton(
                onPressed: pickAndDecryptFile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: CyberpunkColors.hollywoodCerise,
                ),
                child: const Text(
                  'Decrypt File',
                  style: TextStyle(color: CyberpunkColors.fluorescentCyan),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
