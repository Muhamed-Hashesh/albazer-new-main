import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdditionalFeatures extends StatelessWidget {
  const AdditionalFeatures({super.key, required this.additionalFeatures});
  final List<String> additionalFeatures;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'إضافات',
            style: TextStyle(
              color: Theme.of(context).hoverColor,
              fontSize: 18,
              fontFamily: 'Noor',
              fontWeight: FontWeight.w600,
            ),
          ),
          for (int i = 0; i < additionalFeatures.length; i++)
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 7, right: 16),
                  child: Icon(
                    Icons.check_circle,
                    color: Theme.of(context).hoverColor,
                    size: 15.w,
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  additionalFeatures[i],
                  style: TextStyle(
                    color: Theme.of(context).hoverColor,
                    fontSize: 15,
                    fontFamily: 'Noor',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
