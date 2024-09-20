import 'package:app/utils/colors.dart';
import 'package:flutter/material.dart';

class SecureField extends StatelessWidget {
  const SecureField({
    super.key,
    required TextEditingController publicKeyController, required this.labelText, required this.prefixIcon, required this.isPassword,
  }) : _publicKeyController = publicKeyController;

  final String labelText;
  final TextEditingController _publicKeyController;
  final IconData prefixIcon;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: TextField(
        cursorColor: CyberpunkColors.fluorescentCyan,
        style: const TextStyle(color: CyberpunkColors.fluorescentCyan),
        obscureText: isPassword,
        obscuringCharacter: '*',
        controller: _publicKeyController,
        decoration: InputDecoration(
          prefixIcon: Icon(prefixIcon,color: CyberpunkColors.fluorescentCyan,),
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
