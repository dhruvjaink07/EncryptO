import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class EmailService {
  final String username = 'your_email';
  final String password = 'your_password'; // Use app-specific password

  Future<void> sendCCEmail(String recipientEmail, String encryptedMessage, String algorithmName, String shiftVal) async {
    final smtpServer = gmail(username, password);
    print("Sending email to $recipientEmail");

    // Create the message
    final message = Message()
      ..from = Address(username, 'EncryptO')
      ..recipients.add(recipientEmail.trim())
      ..subject = 'Encrypted Message using $algorithmName'
      ..html = '''
        <html>
        <body style="font-family: Arial, sans-serif; background-color: #f4f4f4; padding: 20px;">

          <div style="max-width: 600px; margin: 0 auto; background-color: #ffffff; padding: 20px; border-radius: 8px;">
            <h2 style="color: #333333; text-align: center;">🔒 Encrypted Message from EncryptO</h2>
            
            <p style="color: #555555;">Hello,</p>
            <p style="color: #555555;">You have received an encrypted message using the <b>$algorithmName</b> algorithm. ${shiftVal} is the shiftValue</p>
            
            <div style="background-color: #f8f9fa; padding: 15px; border-radius: 5px; border: 1px solid #dddddd; word-wrap: break-word;">
              <code style="color: #d6336c; font-size: 16px;">
                $encryptedMessage
              </code>
            </div>
            
            <p style="color: #555555;">If you need assistance with decrypting this message, please refer to the instructions or contact support.</p>
            
            <p style="color: #333333;">Best regards,<br><b>Encrypto</b></p>
          </div>
          
          <footer style="text-align: center; margin-top: 20px;">
            <p style="font-size: 12px; color: #aaaaaa;">This data was sent securely using $algorithmName encryption.</p>
            <p style="font-size: 12px; color: #aaaaaa;">&copy; 2024 Encrypto. All Rights Reserved.</p>
          </footer>
        </body>
        </html>
      '''; 

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
// Afine Ciphero
  Future<void> sendAFEmail(String recipientEmail, String encryptedMessage, String algorithmName, String key1, String key2) async {
    final smtpServer = gmail(username, password);
    print("Sending email to $recipientEmail");

    // Create the message
    final message = Message()
      ..from = Address(username, 'EncryptO')
      ..recipients.add(recipientEmail.trim())
      ..subject = 'Encrypted Message using $algorithmName'
      ..html = '''
        <html>
        <body style="font-family: Arial, sans-serif; background-color: #f4f4f4; padding: 20px;">

          <div style="max-width: 600px; margin: 0 auto; background-color: #ffffff; padding: 20px; border-radius: 8px;">
            <h2 style="color: #333333; text-align: center;">🔒 Encrypted Message from EncryptO</h2>
            
            <p style="color: #555555;">Hello,</p>
            <p style="color: #555555;">You have received an encrypted message using the <b>$algorithmName</b> algorithm. $key1 and $key2.</p>
            
            <div style="background-color: #f8f9fa; padding: 15px; border-radius: 5px; border: 1px solid #dddddd; word-wrap: break-word;">
              <code style="color: #d6336c; font-size: 16px;">
                $encryptedMessage
              </code>
            </div>
            
            <p style="color: #555555;">If you need assistance with decrypting this message, please refer to the instructions or contact support.</p>
            
            <p style="color: #333333;">Best regards,<br><b>Encrypto</b></p>
          </div>
          
          <footer style="text-align: center; margin-top: 20px;">
            <p style="font-size: 12px; color: #aaaaaa;">This data was sent securely using $algorithmName encryption.</p>
            <p style="font-size: 12px; color: #aaaaaa;">&copy; 2024 Encrypto. All Rights Reserved.</p>
          </footer>
        </body>
        </html>
      '''; 

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

// PLayfair cipher
Future<void> sendPFEmail(String recipientEmail, String encryptedMessage, String algorithmName) async {
    final smtpServer = gmail(username, password);
    print("Sending email to $recipientEmail");

    // Create the message
    final message = Message()
      ..from = Address(username, 'EncryptO')
      ..recipients.add(recipientEmail.trim())
      ..subject = 'Encrypted Message using $algorithmName'
      ..html = '''
        <html>
        <body style="font-family: Arial, sans-serif; background-color: #f4f4f4; padding: 20px;">

          <div style="max-width: 600px; margin: 0 auto; background-color: #ffffff; padding: 20px; border-radius: 8px;">
            <h2 style="color: #333333; text-align: center;">🔒 Encrypted Message from EncryptO</h2>
            
            <p style="color: #555555;">Hello,</p>
            <p style="color: #555555;">You have received an encrypted message using the <b>$algorithmName</b> algorithm.</p>
            
            <div style="background-color: #f8f9fa; padding: 15px; border-radius: 5px; border: 1px solid #dddddd; word-wrap: break-word;">
              <code style="color: #d6336c; font-size: 16px;">
                $encryptedMessage
              </code>
            </div>
            
            <p style="color: #555555;">If you need assistance with decrypting this message, please refer to the instructions or contact support.</p>
            
            <p style="color: #333333;">Best regards,<br><b>Encrypto</b></p>
          </div>
          
          <footer style="text-align: center; margin-top: 20px;">
            <p style="font-size: 12px; color: #aaaaaa;">This data was sent securely using $algorithmName encryption.</p>
            <p style="font-size: 12px; color: #aaaaaa;">&copy; 2024 Encrypto. All Rights Reserved.</p>
          </footer>
        </body>
        </html>
      '''; 

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

}
