import 'dart:convert';
import 'package:app/Views/key_display_screen.dart';
import 'package:app/utils/rsa_brain.dart';
import 'package:flutter/material.dart';
// For Clipboard functionality
import 'package:app/utils/colors.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/asn1/asn1_parser.dart';
import 'package:pointycastle/asn1/primitives/asn1_integer.dart';
import 'package:pointycastle/asn1/primitives/asn1_sequence.dart';
import 'package:pointycastle/asymmetric/api.dart';

class TextInputScreen extends StatefulWidget {
  final String pageName;
  final String labelText;
  final Widget? nextPage;

  const TextInputScreen({
    super.key,
    required this.pageName,
    required this.labelText,
    this.nextPage,
  });

  @override
  State<TextInputScreen> createState() => _TextInputScreenState();
}

class _TextInputScreenState extends State<TextInputScreen> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _publicKeyController = TextEditingController(); // For recipient's public key

  late AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> keyPair;

  String? encryptedMessage;
  String? decryptedMessage;

  @override
  void initState() {
    super.initState();
    // Generate RSA key pair for the current user
    keyPair = RSAUtils.generateRSAKeyPair(RSAUtils.getSecureRandom(), 2048);
  }

  RSAPublicKey? _parsePublicKey(String pem) {
    try {
      final base64String = pem
          .replaceAll('-----BEGIN PUBLIC KEY-----', '')
          .replaceAll('-----END PUBLIC KEY-----', '')
          .replaceAll(RegExp(r'\s'), '');

      final keyBytes = base64Decode(base64String);
      final asn1Parser = ASN1Parser(keyBytes);

      final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
      final modulus = topLevelSeq.elements?[1] as ASN1Integer;
      final exponent = topLevelSeq.elements?[2] as ASN1Integer;

      final publicKey = RSAPublicKey(modulus.integer!, exponent.integer!);
      return publicKey;
    } catch (e) {
      print('Error parsing public key: $e');
      return null;
    }
  }

  void _encryptMessage() {
    final message = _textController.text;
    final publicKeyPem = _publicKeyController.text;
    final recipientPublicKey = _parsePublicKey(publicKeyPem);

    if (recipientPublicKey != null) {
      final encrypted = RSAUtils.rsaEncrypt(message, recipientPublicKey);
      setState(() {
        encryptedMessage = base64Encode(encrypted);
      });
    } else {
      // Handle invalid public key input
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid recipient public key.')),
      );
    }
  }

  void _decryptMessage() {
    if (encryptedMessage != null) {
      final decodedMessage = base64Decode(encryptedMessage!);
      final decrypted = RSAUtils.rsaDecrypt(decodedMessage, keyPair.privateKey);
      setState(() {
        decryptedMessage = decrypted;
      });
    }
  }

  void _openPublicKeyDisplay() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PublicKeyDisplayScreen(publicKey: keyPair.publicKey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.pageName,
        ),
        backgroundColor: AppColors.highlightEffect,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.icon,
          ),
        ),
        actions: [
          if (widget.nextPage != null)
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => widget.nextPage!),
                );
              },
              icon: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.icon,
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            child: TextField(
              cursorColor: Colors.white,
              style: const TextStyle(color: AppColors.textPrimary),
              controller: _textController,
              decoration: InputDecoration(
                labelText: widget.labelText,
                labelStyle: const TextStyle(color: AppColors.textPrimary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(color: AppColors.border, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(color: AppColors.inputBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(color: AppColors.textPrimary, width: 2.0),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(15),
            child: TextField(
              controller: _publicKeyController,
              decoration: InputDecoration(
                labelText: 'Recipient Public Key (PEM)',
                labelStyle: const TextStyle(color: AppColors.textPrimary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(color: AppColors.border, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(color: AppColors.inputBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(color: AppColors.textPrimary, width: 2.0),
                ),
              ),
            ),
          ),
          Expanded(child: Spacer()),
          SizedBox(
            width: screenWidth / 2.5,
            child: ElevatedButton(
              onPressed: _encryptMessage,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.highlightEffect,
              ),
              child: const Text(
                "Encode",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          if (encryptedMessage != null) ...[
            const SizedBox(height: 10),
            Text("Encrypted Message: $encryptedMessage", style: const TextStyle(color: AppColors.textHighlight)),
          ],
          const SizedBox(height: 10),
          SizedBox(
            width: screenWidth / 2.5,
            child: ElevatedButton(
              onPressed: _decryptMessage,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.highlightEffect,
              ),
              child: const Text(
                "Decode",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (decryptedMessage != null) ...[
            const SizedBox(height: 10),
            Text("Decrypted Message: $decryptedMessage", style: const TextStyle(color: AppColors.textHighlight)),
          ],
        ],
      ),
    );
  }
}
