import 'package:albazar_app/core/utils/colors.dart';
import 'package:albazar_app/core/utils/styles.dart';
import 'package:flutter/material.dart';

class CustomButtonAuth extends StatelessWidget {
  final String title;
  final void Function()? onPressed;
  final Color colorButton;
  final Color colorText;
  const CustomButtonAuth({
    super.key,
    required this.title,
    this.onPressed,
    this.colorButton = Colors.black,
    this.colorText = AppColor.coverPageColor,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      disabledColor: colorButton,
      minWidth: 347,
      height: 50,
      color: colorButton,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: Styles.style20.copyWith(color: colorText, fontFamily: "Noor"),
      ),
    );
  }
}
