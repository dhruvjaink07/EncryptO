import 'package:app/utils/colors.dart';
import 'package:flutter/material.dart';

class EditorScreenTemplate extends StatelessWidget {
  const EditorScreenTemplate({
    super.key,
    required this.controller,
    this.maxLength,
  });

  final TextEditingController controller;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 16.0,
        left: 16.0,
        top: 24.0,
        bottom: 40.0,
      ),
      child: TextField(
        cursorColor: CyberpunkColors.fluorescentCyan,
        style: const TextStyle(color: CyberpunkColors.fluorescentCyan),
        decoration: InputDecoration(
          labelText: "Enter Text",
                    labelStyle: const TextStyle(color: CyberpunkColors.fluorescentCyan),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide:
                const BorderSide(color: CyberpunkColors.zaffre, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: CyberpunkColors.darkViolet),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(
                color: CyberpunkColors.fluorescentCyan, width: 2.0),
          ),
        ),
        controller: controller,
        maxLines: null,
        textInputAction: TextInputAction.done,
      ),
    );
  }
}
