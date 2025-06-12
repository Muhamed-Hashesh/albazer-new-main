import 'package:albazar_app/core/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomLabeledTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final bool? enabled;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function()? onTap;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? prefix, suffix;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  const CustomLabeledTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.prefix,
    this.suffix,
    this.inputFormatters,
    this.maxLines,
    this.enabled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).focusColor,
            fontSize: 16.sp,
            fontFamily: 'Noor',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
            enabled: enabled,
            onTap: onTap,
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            textInputAction: textInputAction,
            validator: validator,
            maxLines: maxLines,
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).highlightColor,
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color.fromARGB(255, 175, 47, 38)),
                borderRadius: BorderRadius.circular(15),
              ),
              prefixIcon: prefix,
              suffixIcon: suffix,
              hintStyle: Styles.style13.copyWith(
                color: const Color(0xff8C8C8C),
              ),
              hintText: hint,
            )),
      ],
    );
  }
}
