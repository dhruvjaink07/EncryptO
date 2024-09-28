import 'dart:io';
import 'package:app/utils/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
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
  String? decryptedContent;

  // Function to pick an encrypted file and read its content
  Future<void> pickEncryptedFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      String content = await file.readAsString();
      setState(() {
        secretMessageController.text = content; // Set the content to the controller
      });
    } else {
      // User canceled the picker
    }
  }

  // Function to save the decrypted content to a file
  Future<void> saveDecryptedFile(String decryptedContent) async {
    final directory = await Directory(Api.directoryPath);
    final file = File('${directory.path}/decrypted_message.txt');
    await file.writeAsString(decryptedContent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberpunkColors.oxfordBlue,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CyberpunkColors.darkViolet,
        toolbarHeight: 60.0,
        leading: AppBarIconButton(
          padding: const EdgeInsets.only(left: 16.0),
          icon: Icons.arrow_back_ios,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          kDecryptButtonTitle,
          style: TextStyle(color: CyberpunkColors.fluorescentCyan, fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        actions: [
          AppBarIconButton(
            padding: const EdgeInsets.only(right: 16.0),
            icon: Icons.arrow_forward_ios,
            onPressed: () async {
              if (secretMessageController.text.trim().isEmpty) {
                // Navigate to ResultPage with a sad message if no input
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
                String? decryptedMessage = _myRsaBrain.decryptTheGetterMessage(secretMessageController.text.trim());

                if (decryptedMessage != null) {
                  // Check if content was obtained from file
                  if (secretMessageController.text != '') {
                    await saveDecryptedFile(decryptedMessage); // Save the decrypted file
                  }
                  // Navigate to ResultPage with the decrypted message
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultPage(
                        message: decryptedMessage,
                        title: kDecryptResultPageTitle,
                        alert: kDecryptResultAlertTitle,
                      ),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ErrorPage(
                        title: kDecryptErrorTitle,
                        description: kDecryptErrorDescription,
                      ),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: Container(
        height: 1000,
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: pickEncryptedFile,
              icon: const Icon(Icons.attach_file),
              label: const Text('Choose Encrypted .txt File'),
              style: ElevatedButton.styleFrom(
                backgroundColor: CyberpunkColors.hollywoodCerise,
              ),
            ),
            EditorScreenTemplate(
              controller: secretMessageController,
            ),
          ],
        ),
      ),
    );
  }
}
