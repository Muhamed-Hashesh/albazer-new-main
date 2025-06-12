import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function()? onTap;
  const CustomButton({
    super.key,
    required this.text,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 115.38,
        padding: const EdgeInsets.symmetric(horizontal: 13.96, vertical: 9.31),
        decoration: ShapeDecoration(
          color: Theme.of(context).hoverColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11.17),
          ),
          shadows: [
            BoxShadow(
              color: Theme.of(context).shadowColor,
              blurRadius: 3.72,
              offset: const Offset(1.86, 3.72),
              spreadRadius: 0,
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).scaffoldBackgroundColor,
                fontSize: 14.89,
                fontFamily: 'Noor',
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Icon(
              icon,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ],
        ),
      ),
    );
  }
}
