import 'dart:convert';
import 'package:app/Views/key_display_screen.dart';
import 'package:app/components/text_input_field.dart';
import 'package:app/utils/colors.dart';
import 'package:app/utils/rsa_brain.dart';
import 'package:flutter/material.dart';
// For Clipboard functionality
import 'package:pointycastle/api.dart';
import 'package:pointycastle/asn1/asn1_parser.dart';
import 'package:pointycastle/asn1/primitives/asn1_integer.dart';
import 'package:pointycastle/asn1/primitives/asn1_sequence.dart';
import 'package:pointycastle/asymmetric/api.dart';


class TextInputScreen extends StatefulWidget {
  final String pageName;
  final String labelText;

  const TextInputScreen({
    super.key,
    required this.pageName,
    required this.labelText,
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
      backgroundColor: CyberpunkColors.oxfordBlue, // Set background color to Cyberpunk theme
      appBar: AppBar(
        title: Text(
          widget.pageName,
          style:const  TextStyle(color: CyberpunkColors.fluorescentCyan),
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
                
              },
              icon: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: CyberpunkColors.fluorescentCyan, // Icon color
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          TextInputField(publicKeyController: _textController, labelText: 'Enter Message'),
          TextInputField(publicKeyController: _publicKeyController,labelText: 'Enter Recepient\'s public key', ),
          Container(
            margin: const EdgeInsets.only(right: 20),
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: screenWidth / 2,
              child: ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>PublicKeyDisplayScreen(publicKey: keyPair.publicKey)));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: CyberpunkColors.hollywoodCerise, // Button color
                ),
                child: const Text(
                  "Your Public key",
                  style: TextStyle(
                    color: CyberpunkColors.fluorescentCyan,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
          const Expanded(child: Spacer()),
          SizedBox(
            width: screenWidth / 2.5,
            child: ElevatedButton(
              onPressed: _encryptMessage,
              style: ElevatedButton.styleFrom(
                backgroundColor: CyberpunkColors.hollywoodCerise, // Button color
              ),
              child: const Text(
                "Encode",
                style: TextStyle(
                  color: CyberpunkColors.fluorescentCyan,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          if (encryptedMessage != null) ...[
            const SizedBox(height: 10),
            Text("Encrypted Message: $encryptedMessage", style: const TextStyle(color: CyberpunkColors.hollywoodCerise)),
          ],
          const SizedBox(height: 10),
          SizedBox(
            width: screenWidth / 2.5,
            child: ElevatedButton(
              onPressed: _decryptMessage,
              style: ElevatedButton.styleFrom(
                backgroundColor: CyberpunkColors.hollywoodCerise, // Button color
              ),
              child: const Text(
                "Decode",
                style: TextStyle(
                  color: CyberpunkColors.fluorescentCyan,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (decryptedMessage != null) ...[
            const SizedBox(height: 10),
            Text("Decrypted Message: $decryptedMessage", style: const TextStyle(color: CyberpunkColors.hollywoodCerise)),
          ],
        ],
      ),
    );
  }
}

