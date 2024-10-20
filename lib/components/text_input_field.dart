import 'package:app/utils/colors.dart';
import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  const TextInputField({
    super.key,
    required TextEditingController publicKeyController, required this.labelText,
  }) : _publicKeyController = publicKeyController;

  final String labelText;
  final TextEditingController _publicKeyController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: TextField(
        cursorColor: CyberpunkColors.fluorescentCyan,
        style: const TextStyle(color: CyberpunkColors.fluorescentCyan),
        controller: _publicKeyController,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: CyberpunkColors.fluorescentCyan),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: CyberpunkColors.zaffre, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: CyberpunkColors.darkViolet),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: CyberpunkColors.fluorescentCyan, width: 2.0),
          ),
        ),
      ),
    );
  }
}
