import 'package:albazar_app/core/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomCardWidget extends StatelessWidget {
  final String text;
  final IconData icon;
  const CustomCardWidget({
    super.key,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).highlightColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColor.coverPageColor,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).focusColor,
                fontSize: 13.49,
                fontFamily: 'Noor',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
