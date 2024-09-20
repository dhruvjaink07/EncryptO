import 'dart:convert';
import 'dart:typed_data';
import 'package:app/Views/text_input_screen.dart';
import 'package:app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard functionality
import 'package:pointycastle/asymmetric/api.dart';

class PublicKeyDisplayScreen extends StatelessWidget {
  final RSAPublicKey publicKey;

  const PublicKeyDisplayScreen({Key? key, required this.publicKey})
      : super(key: key);

  // Converts BigInt to bytes
  Uint8List _bigIntToBytes(BigInt bigInt) {
    final byteArray = bigInt.toRadixString(16).padLeft(64, '0');
    final length = byteArray.length;
    final bytes = Uint8List(length ~/ 2);

    for (int i = 0; i < length; i += 2) {
      bytes[i ~/ 2] = int.parse(byteArray.substring(i, i + 2), radix: 16);
    }

    return bytes;
  }

  // Converts the RSA public key to PEM format
  String _publicKeyToPem(RSAPublicKey publicKey) {
    final modulus = publicKey.modulus!;
    final exponent = publicKey.exponent!;

    final modulusBytes = _bigIntToBytes(modulus);
    final exponentBytes = _bigIntToBytes(exponent);

    final modulusBase64 = base64.encode(modulusBytes);
    final exponentBase64 = base64.encode(exponentBytes);

    return '''
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA$modulusBase64
''';
  }

  void _copyToClipboard(BuildContext context) {
    final keyString = _publicKeyToPem(publicKey); // Convert public key to PEM format
    Clipboard.setData(ClipboardData(text: keyString));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Public Key copied to clipboard!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberpunkColors.oxfordBlue, // Updated background color
      appBar: AppBar(
        title: const Text('Your Public Key'),
        backgroundColor: CyberpunkColors.darkViolet, // Updated AppBar color
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: CyberpunkColors.fluorescentCyan, // Updated icon color
          ),
        ),
       
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    _copyToClipboard(context);
                  },
                  icon: const Icon(
                    Icons.copy,
                    color: CyberpunkColors.hollywoodCerise, // Updated icon color
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _publicKeyToPem(publicKey),
                  style: const TextStyle(
                    fontSize: 16,
                    color: CyberpunkColors.fluorescentCyan, // Updated text color
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
