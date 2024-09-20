import 'package:app/Views/sign-in-up/sign_in.dart';
import 'package:app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future sendEmail() async {
    final username = 'Enter Email';
    final password = 'Less secure pass';

    // Define SMTP server
    final smtpServer = gmail(username, password);

    // Create message
    // Create the message
    final message = Message()
      ..from = Address(username, 'Your Name')
      ..recipients.add('imbetter27h@gmail.com') // Correct recipient email
      ..subject = 'Test Email from Flutter App'
      ..text = 'This is a test email sent from Flutter!';

    try {
      // sending email
      final sendReport = await send(message, smtpServer);
          print('Message sent: ' + sendReport.toString());

    } on MailerException catch (e) {
      print("\n Message not sent");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: CyberpunkColors.oxfordBlue,
      appBar: AppBar(
        backgroundColor: CyberpunkColors.oxfordBlue,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const SignIn()));
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.red,
              ))
        ],
      ),
      body: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 200,
              decoration: const BoxDecoration(
                  color: CyberpunkColors.fluorescentCyan,
                  shape: BoxShape.circle),
            ),
            const SizedBox(
              height: 3,
            ),
            const Text(
              'Dhruv Jain',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              "dhruvjainz",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text('500',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600)),
                    Text('Connextions',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600))
                  ],
                ),
                SizedBox(
                  width: 30,
                ),
                Column(
                  children: [
                    Text('2019',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600)),
                    Text("Joined",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600))
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                sendEmail();
              },
              child: const Text('Send Email'),
            )
          ],
        ),
      ),
    );
  }
}
