import 'package:albazar_app/core/utils/styles.dart';
import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final String? text;
  const CustomDivider({
    super.key,
    this.text = "أو سجل بواسطة",
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Theme.of(context).focusColor, // Line color
            // thickness: 1, // Line thickness
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 8), // Space around text
          child: Text(
            text!,
            style: Styles.style10.copyWith(color: Theme.of(context).focusColor),
          ),
        ),
        Expanded(
          child: Divider(
            color: Theme.of(context).focusColor,
            // thickness: 1,
          ),
        ),
      ],
    );
  }
}
