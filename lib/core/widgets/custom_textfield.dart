import 'package:albazar_app/core/utils/styles.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function()? onPressed, onTap;
  final IconData? icon;
  final Iterable<String>? autofillHints;
  final bool obscureText, readOnly;
  final FocusNode? focusNode;
  const CustomTextField({
    super.key,
    required this.labelText,
    this.controller,
    this.keyboardType,
    this.validator,
    this.onPressed,
    this.onTap,
    this.icon,
    this.obscureText = false,
    this.readOnly = false,
    this.autofillHints,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 17),
      child: IntrinsicHeight(
        child: TextFormField(
          focusNode: focusNode,
          onTap: onTap,
          readOnly: readOnly,
          controller: controller,
          keyboardType: keyboardType,
          autofillHints: autofillHints,
          validator: validator,
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            labelText: labelText,
            labelStyle:
                Styles.style13.copyWith(color: Theme.of(context).hoverColor),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            // label: Text("nasm,"),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(15),
            ),
            errorMaxLines: 2,
            suffixIcon: IconButton(
              color: const Color(0xffADADAD),
              onPressed: onPressed,
              icon: Icon(icon),
            ),
          ),
        ),
      ),
    );
  }
}
