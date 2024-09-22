import 'package:app/components/text_input_field.dart';
import 'package:app/rsa/pages/error_page.dart';
import 'package:app/rsa/pages/result_page.dart';
import 'package:app/rsa/utilities/constants.dart';
import 'package:app/rsa/utilities/rsa_brain.dart';
import 'package:app/rsa/widgets/appbar_icon_button.dart';
import 'package:app/utils/colors.dart';
import 'package:flutter/material.dart';

late RSABrain _myRsaBrain;

class MessageInputPage extends StatefulWidget {
  MessageInputPage({super.key, required rsaBrain}) {
    _myRsaBrain = rsaBrain;
  }

  @override
  State createState() => _MessageInputPageState();
}

class _MessageInputPageState extends State<MessageInputPage> {
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberpunkColors.oxfordBlue,
      appBar: AppBar(
        elevation: 0,
        // Set the elevation to 0 to remove the shadow
        backgroundColor: CyberpunkColors.darkViolet,
        // Set the app bar color here
        toolbarHeight: 60.0,
        leading: AppBarIconButton(
          padding: const EdgeInsets.only(left: 16.0),
          icon: Icons.arrow_back_ios,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          kMessageInputPageTitle,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,color: CyberpunkColors.fluorescentCyan),
        ),
        actions: [
          AppBarIconButton(
            padding: const EdgeInsets.only(right: 16.0),
            icon: Icons.arrow_forward_ios,
            onPressed: () {
              String? secretMessage = _myRsaBrain.encryptTheSetterMessage(
                (messageController.text.trim().length > kMaxTextFieldLength)
                    ? messageController.text
                        .trim()
                        .substring(0, kMaxTextFieldLength)
                    : messageController.text.trim(),
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => (secretMessage != null)
                      ? ResultPage(
                          message: secretMessage,
                          title: kEncryptResultPageTitle,
                          alert: kEncryptResultAlertTitle,
                        )
                      : const ErrorPage(
                          title: kEncryptErrorTitle,
                          description: kEncryptErrorDescription,
                        ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: TextInputField(publicKeyController: messageController, labelText: 'Enter Text')
      ),
    );
  }
}
