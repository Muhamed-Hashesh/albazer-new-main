import 'package:albazar_app/core/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomLabeledDropDownField extends StatelessWidget {
  final String label;
  final String? hint, value;

  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final List<String> items;

  final Widget? prefix, suffix;

  const CustomLabeledDropDownField({
    super.key,
    required this.label,
    this.hint,
    this.validator,
    this.prefix,
    this.suffix,
    required this.items,
    this.value,
    this.onChanged,
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
        DropdownButtonFormField(
            dropdownColor: Theme.of(context).highlightColor,
            icon: Icon(
              Icons.keyboard_arrow_down_sharp,
              size: 28.w,
              color: Styles.style13
                  .copyWith(
                    color: const Color(0xff8C8C8C),
                  )
                  .color,
            ),
            value: value,
            items: items
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    ))
                .toList(),
            onChanged: onChanged,
            validator: validator,
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).highlightColor,
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
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
