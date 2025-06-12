import 'package:albazar_app/core/utils/colors.dart';
import 'package:albazar_app/core/utils/styles.dart';
import 'package:flutter/material.dart';

class CustomSectionConfirm extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool>? onChanged;
  const CustomSectionConfirm({
    super.key,
    required this.isChecked,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          activeColor: Colors.black,
          checkColor: AppColor.coverPageColor,

          onChanged: (value) {
            if (value != null) {
              onChanged!(value);
            }
          },
          visualDensity: VisualDensity.compact, // Reduce default padding
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "موافق على الشروط والاحكام",
                style:
                    Styles.style9.copyWith(color: Theme.of(context).focusColor),
              ),
              Text(
                "برجاء الموافقة علي الشروط و الأحكام لعرض إعلانك",
                style: Styles.style9.copyWith(
                    decoration: TextDecoration.underline,
                    color: Theme.of(context).focusColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
