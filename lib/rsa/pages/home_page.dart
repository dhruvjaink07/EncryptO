import 'package:app/rsa/pages/decrypt_input_page.dart';
import 'package:app/rsa/pages/message_encrypt.dart';
import 'package:app/rsa/utilities/constants.dart';
import 'package:app/rsa/utilities/rsa_brain.dart';
import 'package:app/rsa/widgets/copy_icon_button.dart';
import 'package:app/utils/colors.dart';
import 'package:flutter/material.dart';

class HomePageRsa extends StatefulWidget {
  const HomePageRsa({super.key});

  @override
  State createState() => _HomePageRsaState();
}

class _HomePageRsaState extends State<HomePageRsa> {
  late RSABrain _myRsaBrain;

  @override
  void initState() {
    super.initState();
    _myRsaBrain = RSABrain();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberpunkColors.oxfordBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      kPublicKeyTitle,
                      style: TextStyle(color: CyberpunkColors.fluorescentCyan, fontSize: 18,fontWeight: FontWeight.bold),
                    ),
                  ),
                  CopyIconButton(
                    clipboardDataText: _myRsaBrain.getOwnPublicKey().toString(),
                    alertText: kPublicKeyAlertTitle,
                    iconSize: 23.5,
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Text(
                    _myRsaBrain.getOwnPublicKey().toString(),
                    textAlign: TextAlign.justify,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PublicKeyInputPage(
                        rsaBrain: _myRsaBrain,
                      ),
                    ),
                  );
                },
                child: const Text('Encrypt'),
              ),
              const SizedBox(
                height: 24.0,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DecryptInputPage(
                        rsaBrain: _myRsaBrain,
                      ),
                    ),
                  );
                },
                child: const Text('Decrypt'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
