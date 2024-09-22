
import 'package:app/rsa/pages/error_page.dart';
import 'package:app/rsa/pages/result_page.dart';
import 'package:app/rsa/utilities/rsa_brain.dart';
import 'package:app/rsa/widgets/appbar_icon_button.dart';
import 'package:app/rsa/widgets/editor_screen_template.dart';
import 'package:app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:app/rsa/utilities/constants.dart';
late RSABrain _myRsaBrain;

class DecryptInputPage extends StatefulWidget {
  DecryptInputPage({super.key, required rsaBrain}) {
    _myRsaBrain = rsaBrain;
  }

  @override
  State createState() => _DecryptInputPageState();
}

class _DecryptInputPageState extends State<DecryptInputPage> {
  TextEditingController secretMessageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberpunkColors.oxfordBlue,
      appBar: AppBar(
        elevation: 0, // Set the elevation to 0 to remove the shadow
        backgroundColor: CyberpunkColors.darkViolet, // Set the app bar color here
        toolbarHeight: 60.0,
        leading: AppBarIconButton(
          padding: const EdgeInsets.only(left: 16.0),
          icon: Icons.arrow_back_ios,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          kDecryptButtonTitle,
          style: TextStyle(color: CyberpunkColors.fluorescentCyan,fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        actions: [
          AppBarIconButton(
            padding: const EdgeInsets.only(right: 16.0),
            icon: Icons.arrow_forward_ios,
            onPressed: () {
              if (secretMessageController.text.trim() == "") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultPage(
                      message: kSadSmiley,
                      title: kDecryptResultPageTitle,
                      alert: kDecryptResultAlertTitle,
                    ),
                  ),
                );
              } else {
                String? message = _myRsaBrain.decryptTheGetterMessage(
                    secretMessageController.text.trim());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => (message != null)
                        ? ResultPage(
                      message: message,
                      title: kDecryptResultPageTitle,
                      alert: kDecryptResultAlertTitle,
                    )
                        : const ErrorPage(
                            title: kDecryptErrorTitle,
                      description: kDecryptErrorDescription,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
        body: Container(
          height: 1000,
          // color: CyberpunkColors.oxfordBlue, // Set the background color of the body
          child: EditorScreenTemplate(
            controller: secretMessageController,
          ),
        ),
    );
  }
}
