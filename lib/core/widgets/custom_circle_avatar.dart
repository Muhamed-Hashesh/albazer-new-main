import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCircleAvatar extends StatelessWidget {
  final IconData icon;
  final void Function()? onTap;
  const CustomCircleAvatar({
    super.key,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).hoverColor,
            ),
            borderRadius: BorderRadius.circular(30)),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Icon(
            icon,
            color: Theme.of(context).focusColor,
            size: 30.w,
          ),
        ),
      ),
    );
  }
}
