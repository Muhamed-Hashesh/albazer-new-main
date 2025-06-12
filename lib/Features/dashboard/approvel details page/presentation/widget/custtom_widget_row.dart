import 'package:flutter/material.dart';

class CustomWidgetRow extends StatelessWidget {
  final String text;
  final String number;
  const CustomWidgetRow({
    super.key,
    required this.text,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          textAlign: TextAlign.right,
          style: const TextStyle(
            color: Color(0xFF1D1D1B),
            fontSize: 17.66,
            fontFamily: 'Noor',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          width: 50,
        ),
        Container(
          width: 37.54,
          padding:
              const EdgeInsets.symmetric(horizontal: 11.04, vertical: 5.52),
          decoration: ShapeDecoration(
            color: const Color(0xFFF6F9FF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(11.04),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                number,
                style: TextStyle(
                  color: Theme.of(context).hoverColor,
                  fontSize: 15,
                  fontFamily: 'Simplified Arabic',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
