import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final Color backgroundColor;
  final TextStyle textStyle;
  final String title;
  final void Function()? onPressed;
  const CustomButton({
    super.key,
    required this.backgroundColor,
    required this.textStyle,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 185.w,
      height: 54.h,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side:  BorderSide(
            width: 2.5.w,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: const Color(0xFF1E1E1E),
          )),
      onPressed: onPressed,
      child: Text(
        title,
        style: textStyle,
      ),
    );
  }
}
