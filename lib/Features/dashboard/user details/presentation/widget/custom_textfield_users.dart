import 'package:albazar_app/core/utils/styles.dart';
import 'package:flutter/material.dart';

class CustomTextFieldUsers extends StatelessWidget {
  final String lable;
  final String hintText;
  final TextEditingController controller;
  final Widget? icon;
  const CustomTextFieldUsers({
    super.key,
    required this.lable,
    required this.hintText,
    required this.controller,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 10, right: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lable,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Theme.of(context).focusColor,
              fontSize: 13,
              fontFamily: 'Noor',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            onTap: () {},
            readOnly: true,
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Color(0xFF8C8C8C),
                fontSize: 13,
                fontFamily: 'Noor',
                fontWeight: FontWeight.w400,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              labelStyle: Styles.style13,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              // label: Text("nasm,"),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              errorMaxLines: 2,
              suffixIcon: icon,
              // suffixIcon: IconButton(
              //   color: const Color(0xffADADAD),
              //   onPressed: onPressed,
              //   icon: Icon(icon),
              // ),
            ),
          ),
        ],
      ),
    );
  }
}
