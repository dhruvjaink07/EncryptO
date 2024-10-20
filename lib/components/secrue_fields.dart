import 'package:app/utils/colors.dart';
import 'package:flutter/material.dart';

class SecureField extends StatelessWidget {
  const SecureField({
    super.key,
    required this.publicKeyController, 
    required this.labelText, 
    required this.prefixIcon, 
    required this.isPassword,
    this.validator, // Add the validator field
  });

  final String labelText;
  final TextEditingController publicKeyController;
  final IconData prefixIcon;
  final bool isPassword;
  final String? Function(String?)? validator; // Validator for input

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: TextFormField( // Changed from TextField to TextFormField for validation
        cursorColor: CyberpunkColors.fluorescentCyan,
        style: const TextStyle(color: CyberpunkColors.fluorescentCyan),
        obscureText: isPassword,
        obscuringCharacter: '*',
        controller: publicKeyController,
        validator: validator, // Use validator if provided
        decoration: InputDecoration(
          prefixIcon: Icon(
            prefixIcon,
            color: CyberpunkColors.fluorescentCyan,
          ),
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
