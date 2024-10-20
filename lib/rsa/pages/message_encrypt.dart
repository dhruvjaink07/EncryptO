import 'package:app/components/text_input_field.dart';
import 'package:app/rsa/pages/message_input_page.dart';
import 'package:app/rsa/utilities/constants.dart';
import 'package:app/rsa/utilities/rsa_brain.dart';
import 'package:app/rsa/widgets/appbar_icon_button.dart';
import 'package:app/utils/colors.dart';
import 'package:flutter/material.dart';


late RSABrain _myRsaBrain;

class PublicKeyInputPage extends StatefulWidget {
  PublicKeyInputPage({super.key, required RSABrain rsaBrain}) {
    _myRsaBrain = rsaBrain;
  }

  @override
  State createState() => _PublicKeyInputPageState();
}

class _PublicKeyInputPageState extends State<PublicKeyInputPage> {
  TextEditingController publicKeyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberpunkColors.oxfordBlue,
      appBar: AppBar(
        backgroundColor:CyberpunkColors.darkViolet,
        elevation: 0,
        toolbarHeight: 60.0,
        leading: AppBarIconButton(
          padding: const EdgeInsets.only(left: 16.0),
          icon: Icons.arrow_back_ios,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Receiver\'s public key',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,color: CyberpunkColors.fluorescentCyan),
        ),
        actions: [
          AppBarIconButton(
            padding: const EdgeInsets.only(right: 16.0),
            icon: Icons.arrow_forward_ios,
            onPressed: () {
              _myRsaBrain.setReceiverPublicKey(publicKeyController.text.trim());
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MessageInputPage(
                    rsaBrain: _myRsaBrain,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: TextInputField(
          publicKeyController: publicKeyController,
          labelText: 'Enter receiver\'s public key',
        ),
      ),
    );
  }
}
