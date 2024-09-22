import 'package:app/components/text_input_field.dart';
import 'package:app/services/emailService.dart';
import 'package:app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class PlayfairCipherScreen extends StatefulWidget {
  const PlayfairCipherScreen({super.key});

  @override
  State createState() => _PlayfairCipherScreenState();
}

class _PlayfairCipherScreenState extends State<PlayfairCipherScreen> {
  final textController = TextEditingController();
  String resultText = '';
  String recipientEmail = '';

  void encryptText() {
    final text = textController.text.toUpperCase();
    const key = "KEY";
    String cipherText = playfairEncrypt(text, key);
    setState(() {
      resultText = cipherText;
    });
  }

  String playfairEncrypt(String text, String key) {
    // Convert input text and key to uppercase and remove non-alphabetic characters
    text = text.replaceAll(RegExp(r'[^A-Z]'), '').toUpperCase();
    key = key.replaceAll(RegExp(r'[^A-Z]'), '').toUpperCase();

    // Generate 5x5 Playfair matrix using the key
    String alphabet = 'ABCDEFGHIKLMNOPQRSTUVWXYZ'; // no 'J' in Playfair
    String matrix = key + alphabet;
    matrix = matrix.replaceAll(RegExp(r'J'), ''); // remove 'J' from matrix
    matrix = matrix.split('').toSet().toList().join(); // remove duplicates
    matrix = matrix.padRight(25, 'X'); // fill up to 25 characters with 'X'
    List<List<String>> playfairMatrix =
        List.generate(5, (i) => List.generate(5, (j) => matrix[i * 5 + j]));

    // Replace pairs of characters in input text with their corresponding cipher pairs
    String cipherText = '';
    for (int i = 0; i < text.length; i += 2) {
      String a = text[i];
      String b = i + 1 < text.length ? text[i + 1] : 'X';

      // Find row and column indices for both characters
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

      // Handle the case when variables are not assigned
      aRow ??= 0;
      aCol ??= 0;
      bRow ??= 0;
      bCol ??= 0;

      // If both characters are in the same row, replace them with the characters to their right
      if (aRow == bRow) {
        cipherText += playfairMatrix[aRow][(aCol + 1) % 5];
        cipherText += playfairMatrix[bRow][(bCol + 1) % 5];
      }
      // If both characters are in the same column, replace them with the characters below them
      else if (aCol == bCol) {
        cipherText += playfairMatrix[(aRow + 1) % 5][aCol];
        cipherText += playfairMatrix[(bRow + 1) % 5][bCol];
      }
      // If neither is true, replace them with the characters at the opposite corners of their respective rectangles
      else {
        cipherText += playfairMatrix[aRow][bCol];
        cipherText += playfairMatrix[bRow][aCol];
      }
    }
    return cipherText;
  }

  //code for dycription
  void decryptText() {
    final text = textController.text.toUpperCase();
    const key = "KEY"; // Replace with your own key
    String plainText = playfairDecrypt(text, key);
    setState(() {
      resultText = plainText;
    });
  }

String playfairDecrypt(String text, String key) {
  // Convert input text and key to uppercase and remove non-alphabetic characters
  text = text.replaceAll(RegExp(r'[^A-Z]'), '').toUpperCase();
  key = key.replaceAll(RegExp(r'[^A-Z]'), '').toUpperCase();

  // Generate 5x5 Playfair matrix using the key
  String alphabet = 'ABCDEFGHIKLMNOPQRSTUVWXYZ'; // no 'J' in Playfair
  String matrix = key + alphabet;
  matrix = matrix.replaceAll(RegExp(r'J'), ''); // remove 'J' from matrix
  matrix = matrix.split('').toSet().toList().join(); // remove duplicates
  matrix = matrix.padRight(25, 'X'); // fill up to 25 characters with 'X'
  List<List<String>> playfairMatrix =
      List.generate(5, (i) => List.generate(5, (j) => matrix[i * 5 + j]));

  // Replace pairs of characters in input text with their corresponding plaintext pairs
  String plainText = '';
  for (int i = 0; i < text.length; i += 2) {
    String a = text[i];
    String b = i + 1 < text.length ? text[i + 1] : 'X'; // Default to 'X'

    // Find row and column indices for both characters
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

    // If both characters are in the same row, replace them with the characters to their left
    if (aRow == bRow) {
      plainText += playfairMatrix[aRow][(aCol + 4) % 5];
      plainText += playfairMatrix[bRow][(bCol + 4) % 5];
    }
    // If both characters are in the same column, replace them with the characters above them
    else if (aCol == bCol) {
      plainText += playfairMatrix[(aRow + 4) % 5][aCol];
      plainText += playfairMatrix[(bRow + 4) % 5][bCol];
    }
    // If neither is true, replace them with the characters at the opposite corners of their respective rectangles
    else {
      plainText += playfairMatrix[aRow][bCol];
      plainText += playfairMatrix[bRow][aCol];
    }
  }

  // Remove the trailing 'X' if it was added as padding and is not needed
  if (plainText.endsWith('X') && text.length % 2 == 0) {
    plainText = plainText.substring(0, plainText.length - 1);
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
    textController.dispose();
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
                    EmailService().sendPFEmail(recipientEmail, resultText, "Playfair Cipher"); // Call email sending function
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
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: CyberpunkColors.oxfordBlue,
      appBar: AppBar(
        title: const Text(
          'PlayFair Cipher',style: TextStyle(color: CyberpunkColors.fluorescentCyan),
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
    Tooltip(
      message: 'Utilizes a 5x5 matrix of letters to encrypt pairs of letters in the plaintext.',      preferBelow: true,
      waitDuration: const Duration(milliseconds: 1000),
      child: IconButton(
        onPressed: () {
          // You can add any action here if needed
        },
        icon: const Icon(
          Icons.info,
          color: CyberpunkColors.fluorescentCyan, // Icon color
        ),
      ),
    ),
  ],
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextInputField(publicKeyController: textController, labelText: 'Enter Text'),
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
                      child: Text('Result: $resultText',style: const TextStyle(color: CyberpunkColors.fluorescentCyan,),),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy,color: CyberpunkColors.fluorescentCyan,),
                      onPressed: copyResult,
                    ),
                  ],
                ),
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
    );
  }
}