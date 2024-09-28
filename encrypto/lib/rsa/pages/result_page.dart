import 'package:app/components/text_input_field.dart';
import 'package:app/rsa/utilities/constants.dart';
import 'package:app/rsa/widgets/appbar_icon_button.dart';
import 'package:app/rsa/widgets/copy_icon_button.dart';
import 'package:app/rsa/widgets/message_bubble.dart';
import 'package:app/services/emailService.dart';
import 'package:app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

late String _message;
late String _title;
late String _alert;


class ResultPage extends StatefulWidget {
  ResultPage({super.key, required message, required title, required alert}) {
    _message = message;
    _title = title;
    _alert = alert;
  }

  @override
  State createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
 final phoneController = TextEditingController();
// Add these methods to your _CaesarCipherScreenState class

  launchWhatsAppUri(String phoneNumber) async {
    final link = WhatsAppUnilink(
      phoneNumber: phoneNumber,
      text: "Message ${_message}",
    );
    // Correctly convert to Uri using toString()
    final uri = Uri.parse(link.toString());

    try {
      await launchUrl(uri);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to launch WhatsApp')),
      );
    }
  }

  void showPhoneNumberDialog() {
    String phoneNumber = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: CyberpunkColors.oxfordBlue,
          title: const Text(
            'Enter Phone Number',
            style: TextStyle(color: CyberpunkColors.fluorescentCyan),
          ),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0, vertical: 8.0), // Reduced padding

          content: TextInputField(
              publicKeyController: phoneController,
              labelText: 'Phone Number (with country code)'),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: CyberpunkColors.darkViolet),
              ),
              onPressed: () {
                phoneController.clear();
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text(
                'Send',
                style: TextStyle(color: CyberpunkColors.darkViolet),
              ),
              onPressed: () {
                if (phoneController.text.isNotEmpty) {
                  Navigator.of(context).pop(); // Close the dialog
                  phoneNumber = phoneController.text;
                  launchWhatsAppUri(
                      phoneNumber); // Launch WhatsApp with the entered phone number
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please enter a valid phone number')),
                  );
                }
                phoneController.clear();
              },
            ),
          ],
        );
      },
    );
  }
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
        title: Text(
          _title,
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,color: CyberpunkColors.fluorescentCyan),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CopyIconButton(
              clipboardDataText: _message,
              alertText: _alert,
              iconSize: 20.0,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          MessageBubble(
            text: _message,
          ),
          Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                    const Text('Share on: ',style: TextStyle(color: Colors.white),),
                    IconButton(onPressed: showPhoneNumberDialog, icon: const FaIcon(FontAwesomeIcons.whatsapp, color: CyberpunkColors.fluorescentCyan,))
                  ]),
        ],
      ),
    );
  }
}
