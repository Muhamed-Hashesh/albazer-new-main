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
            height: ad.amenities!.length < 3
                ? 80
                : ad.amenities!.length > 3 && ad.amenities!.length < 6
                    ? 120
                    : ((ad.amenities!.length / 3).floor()) * 80,
            // color: Colors.amber,
            child: GridView.builder(
              itemCount: ad.amenities!.length,
              // physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2,
              ),
              itemBuilder: (context, index) => CustomWidgetColumn(
                text: text2[index],
                image: icons2[index],
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
