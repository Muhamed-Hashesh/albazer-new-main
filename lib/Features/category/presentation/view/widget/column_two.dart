import 'package:albazar_app/Features/ads/data/models/ad.dart';
import 'package:albazar_app/Features/category/presentation/view/widget/custom_widget_column.dart';
import 'package:albazar_app/core/utils/styles.dart';
import 'package:flutter/material.dart';

class ColumnTwo extends StatelessWidget {
  final Ad ad;
  const ColumnTwo({
    super.key,
    required this.icons2,
    required this.text2,
    required this.ad,
  });

  final List<String> icons2;
  final List<String> text2;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'المرافق و وسائل الراحة',
          style: TextStyle(
            color: Theme.of(context).hoverColor,
            fontSize: 18,
            fontFamily: 'Noor',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
            // width: 350,
            height: () {
              int actualCount = [
                ad.amenities!.length,
                text2.length,
                icons2.length
              ].reduce((a, b) => a < b ? a : b);
              return actualCount < 3
                  ? 80.0
                  : actualCount > 3 && actualCount < 6
                      ? 120.0
                      : ((actualCount / 3).floor()) * 80.0;
            }(),
            // color: Colors.amber,
            child: GridView.builder(
              itemCount: [ad.amenities!.length, text2.length, icons2.length]
                  .reduce((a, b) => a < b ? a : b),
              // physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2,
              ),
              itemBuilder: (context, index) => CustomWidgetColumn(
                text: index < text2.length ? text2[index] : 'غير محدد',
                image: index < icons2.length
                    ? icons2[index]
                    : 'assets/icons/star.svg',
                style: Styles.style8
                    .copyWith(color: Theme.of(context).focusColor)
                    .copyWith(fontSize: 12),
              ),
            )),
        // const SizedBox(
        //   height: 10,
        // ),
      ],
    );
  }
}
