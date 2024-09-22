import 'package:app/rsa/utilities/constants.dart';
import 'package:app/rsa/widgets/appbar_icon_button.dart';
import 'package:app/utils/colors.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key, required this.title, required this.description});

  final String title;
  final String description;

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
          'Error',
          style: TextStyle(fontSize: 18.0,color: CyberpunkColors.fluorescentCyan, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
              const SizedBox(height: 16.0),
              Text(
                description,
                style: const TextStyle(fontSize: 16.0, color: CyberpunkColors.fluorescentCyan),
              ),
              const SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
    );
  }
}
