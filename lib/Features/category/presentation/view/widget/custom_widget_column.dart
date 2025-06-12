import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomWidgetColumn extends StatelessWidget {
  final String text;
  final String image;
  final iconHeghit;
  final TextStyle? style;
  const CustomWidgetColumn({
    super.key,
    required this.text,
    required this.image,
    this.style,
    this.iconHeghit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          image,
          height: iconHeghit ?? 17.0,
          // ignore: deprecated_member_use
          color: Theme.of(context).focusColor,
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          text,
          style: style ??
              TextStyle(
                color: Theme.of(context).focusColor,
                fontSize: 12.sp,
                fontFamily: 'Noor',
                fontWeight: FontWeight.w400,
              ),
        ),
      ],
    );
  }
}
