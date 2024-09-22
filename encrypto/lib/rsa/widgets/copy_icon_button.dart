
import 'package:app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyIconButton extends StatelessWidget {
  const CopyIconButton({
    super.key,
    required this.clipboardDataText,
    required this.alertText,
    required this.iconSize,
  });

  final String clipboardDataText;
  final String alertText;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        iconSize: iconSize,
        onPressed: () {
          Clipboard.setData(ClipboardData(text: clipboardDataText)).then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  alertText,
                ),
              ),
            );
          });
        },
        icon: const Icon(Icons.copy,color: CyberpunkColors.fluorescentCyan,));
  }
}
