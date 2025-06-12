import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  final String text;
  final bool? isChecked;
  final Function(bool?)? onChanged;
  const CustomCheckBox({
    super.key,
    required this.text,
    this.isChecked = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged != null
          ? () {
              onChanged!(!isChecked!);
            }
          : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).hoverColor, width: 2),
            ),
            child: CheckboxTheme(
              data: CheckboxThemeData(
                side: BorderSide.none,
                checkColor:
                    WidgetStateProperty.all(Theme.of(context).hoverColor),
                fillColor: WidgetStateProperty.all(Colors.transparent),
              ),
              child: Checkbox(
                value: isChecked,
                activeColor: Colors.transparent,

                // checkColor: Theme.of(context).hoverColor,
                // shape: const RoundedRectangleBorder(
                //   side: BorderSide(color: Theme.of(context).hoverColor),
                // ),

                onChanged: onChanged,
                visualDensity: VisualDensity.compact, // Reduce default padding
                // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            text,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Theme.of(context).focusColor,
              fontSize: 13,
              fontFamily: 'Noor',
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }
}
