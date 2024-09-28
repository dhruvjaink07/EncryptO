import 'dart:io';
import 'package:app/utils/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart'; // Add this import
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
  String? fileContent; // To store file contents

  // Function to pick a file and read its content
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      String content = await file.readAsString();
      setState(() {
        fileContent = content;
      });
    } else {
      // User canceled the picker
      setState(() {
        fileContent = null;
      });
    }
  }

  // Function to save the encrypted file
  Future<void> saveFile(String content) async {
    final directory = await Directory(Api.directoryPath); // Use getApplicationDocumentsDirectory() for file path
    String fileName = 'encrypted_message.txt'; // Define your file name
    File file = File('${directory.path}/$fileName');
    await file.writeAsString(content); // Save the content to the file
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Encrypted file saved at ${file.path}')),
    );
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
          kMessageInputPageTitle,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: CyberpunkColors.fluorescentCyan),
        ),
        actions: [
          AppBarIconButton(
            padding: const EdgeInsets.only(right: 16.0),
            icon: Icons.arrow_forward_ios,
            onPressed: () async {
              // Check if file content is present, else use text input
              String inputMessage = fileContent ?? messageController.text.trim();

              // Encrypt the message
              String? secretMessage = _myRsaBrain.encryptTheSetterMessage(inputMessage);

              // If the message comes from a file, save it instead of navigating to ResultPage
              if (fileContent != null) {
                if (secretMessage != null) {
                  await saveFile(secretMessage); // Save the encrypted message
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ErrorPage(
                        title: kEncryptErrorTitle,
                        description: kEncryptErrorDescription,
                      ),
                    ),
                  );
                }
              } else {
                // Navigate to the ResultPage with the encrypted message
                if (secretMessage != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultPage(
                          message: secretMessage,
                          title: kEncryptResultPageTitle,
                          alert: kEncryptResultAlertTitle,
                        )
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ErrorPage(
                        title: kEncryptErrorTitle,
                        description: kEncryptErrorDescription,
                      ),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            // Text input field for manual message input
            TextInputField(
              publicKeyController: messageController,
              labelText: 'Enter Text',
            ),
            const SizedBox(height: 10),

            // Button to pick a file
            ElevatedButton.icon(
              onPressed: pickFile,
              icon: const Icon(Icons.attach_file),
              label: const Text('Choose .txt File'),
              style: ElevatedButton.styleFrom(
                backgroundColor: CyberpunkColors.hollywoodCerise,
              ),
            ),

            // Display the content of the file if it's picked
            if (fileContent != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  fileContent!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
