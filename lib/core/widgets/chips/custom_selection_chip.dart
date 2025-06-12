import 'package:albazar_app/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSelectionChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool inDashboard;
  final ValueChanged<String> onSelect;
  const CustomSelectionChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelect,
    this.inDashboard = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // if (isSelected) {
        //   onSelect('');
        //   return;
        // }
        onSelect(label);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 86.w,
        height: 36.h,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.coverPageColor : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color:
                isSelected ? Colors.transparent : Theme.of(context).hoverColor,
          ),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected
                  ? inDashboard
                      ? Theme.of(context).secondaryHeaderColor
                      : const Color(0xff8C8C8C)
                  : Theme.of(context).hoverColor,
              fontSize: 12.sp,
              fontFamily: 'Noor',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
