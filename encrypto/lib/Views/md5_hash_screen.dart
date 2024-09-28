import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/utils/colors.dart';
import 'package:app/services/emailService.dart';

class MD5HashScreen extends StatefulWidget {
  const MD5HashScreen({super.key});

  @override
  State createState() => _MD5HashScreenState();
}

class _MD5HashScreenState extends State<MD5HashScreen> {
  final textController = TextEditingController();
  String resultText = '';
  String recipientEmail = '';

  /// Hashes the text using MD5
  void hashText() {
    final text = textController.text;
    String hash = generateMd5(text);
    setState(() {
      resultText = hash;
    });
  }

  /// Generates MD5 hash from the input text
  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  /// Copies the result to the clipboard
  void copyResult() {
    Clipboard.setData(ClipboardData(text: resultText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Result copied to clipboard')),
    );
  }

  /// Shows a bottom sheet to input email and send the result
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
                      // EmailService.sendEmail(
                      //   recipientEmail,
                      //   'MD5 Hash Result',
                      //   resultText,
                      // );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CyberpunkColors.darkViolet,
        title: const Text('MD5 Hashing', style: TextStyle(color: CyberpunkColors.fluorescentCyan)),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                textController.clear();
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'MD5 Hashing Example',
              style: TextStyle(fontSize: 24, color: CyberpunkColors.fluorescentCyan),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                labelText: 'Enter Text',
                hintText: 'Input text to hash',
                labelStyle: TextStyle(color: CyberpunkColors.fluorescentCyan),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: CyberpunkColors.fluorescentCyan),
                ),
              ),
              style: const TextStyle(color: CyberpunkColors.fluorescentCyan),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: hashText,
              style: ElevatedButton.styleFrom(
                backgroundColor: CyberpunkColors.hollywoodCerise,
              ),
              child: const Text(
                'Generate MD5 Hash',
                style: TextStyle(color: CyberpunkColors.fluorescentCyan),
              ),
            ),
            const SizedBox(height: 20),
            SelectableText(
              'Result: $resultText',
              style: const TextStyle(color: CyberpunkColors.fluorescentCyan),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: copyResult,
              style: ElevatedButton.styleFrom(
                backgroundColor: CyberpunkColors.hollywoodCerise,
              ),
              child: const Text(
                'Copy Result',
                style: TextStyle(color: CyberpunkColors.fluorescentCyan),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: showEmailBottomSheet,
              style: ElevatedButton.styleFrom(
                backgroundColor: CyberpunkColors.hollywoodCerise,
              ),
              child: const Text(
                'Send via Email',
                style: TextStyle(color: CyberpunkColors.fluorescentCyan),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
