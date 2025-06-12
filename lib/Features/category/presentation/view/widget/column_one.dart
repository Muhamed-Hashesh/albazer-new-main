import 'package:albazar_app/Features/ads/data/models/ad.dart';
import 'package:albazar_app/Features/category/presentation/view/widget/custom_widget_column.dart';
import 'package:albazar_app/core/utils/icons.dart';
import 'package:albazar_app/core/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ColumnOne extends StatelessWidget {
  final Ad ad;
  const ColumnOne({
    super.key,
    required this.icons,
    required this.text,
    required this.ad,
  });

  final List<String> icons;
  final List<String> text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              ad.id!,
              style: TextStyle(
                color: Theme.of(context).hoverColor.withOpacity(.5),
                fontSize: 12,
                fontFamily: 'Noor',
                fontWeight: FontWeight.w200,
              ),
            ),
            Text(
              '${ad.createdAt.day}/${ad.createdAt.month}/${ad.createdAt.year}',
              style: TextStyle(
                color: Theme.of(context).hoverColor.withOpacity(.5),
                fontSize: 12,
                fontFamily: 'Noor',
                fontWeight: FontWeight.w200,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              ad.currency == 'دولار'
                  ? 'السعر: ${ad.price ?? ad.rentalFees ?? ad.downPayment} USD'
                  : 'السعر: ${ad.price ?? ad.rentalFees ?? ad.downPayment} SYP',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Theme.of(context).hoverColor,
                fontSize: 18,
                fontFamily: 'Noor',
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            SvgPicture.asset(
              AppIcons.edit,
              // ignore: deprecated_member_use
              color: Theme.of(context).hoverColor,
            ),
            Text(
              ad.negotiable ?? false ? 'قابل للتفاوض' : 'غير قابل للتفاوض',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Theme.of(context).hoverColor,
                fontSize: 13,
                fontFamily: 'Noor',
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          ad.adTitle,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: Theme.of(context).hoverColor,
            fontSize: 22,
            fontFamily: 'Noor',
            fontWeight: FontWeight.w400,
          ),
        ),
        Wrap(
          children: [
            if (ad.propertyType != null && ad.propertyType!.isNotEmpty)
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 8, start: 12),
                child: CustomWidgetColumn(
                  text: ad.propertyType!,
                  image: AppIcons.one,
                  // style: Styles.style8.copyWith(
                  //    color: Theme.of(context).focusColor, fontSize: 10),
                ),
              ),
            if (ad.kilometers != null && ad.kilometers!.isNotEmpty)
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 8, start: 18),
                child: CustomWidgetColumn(
                  text: ad.kilometers!,
                  image: AppIcons.km,
                  // style: Styles.style8.copyWith(
                  //    color: Theme.of(context).focusColor, fontSize: 10),
                ),
              ),
            if (ad.downPayment != null && ad.downPayment!.isNotEmpty)
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 8, start: 18),
                child: CustomWidgetColumn(
                  text: ad.downPayment!,
                  image: AppIcons.two,
                  // style: Styles.style8.copyWith(
                  //    color: Theme.of(context).focusColor, fontSize: 10),
                ),
              ),
            if (ad.area != null && ad.area! != 0)
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 8, start: 18),
                child: CustomWidgetColumn(
                  text: "${ad.area!} متر مربع",
                  image: AppIcons.three,
                  // style: Styles.style8.copyWith(
                  //    color: Theme.of(context).focusColor, fontSize: 10),
                ),
              ),
            if (ad.deliveryConditions != null &&
                ad.deliveryConditions!.isNotEmpty)
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 8, start: 18),
                child: CustomWidgetColumn(
                  text: ad.deliveryConditions!,
                  image: AppIcons.six,
                  // style: Styles.style8.copyWith(
                  //    color: Theme.of(context).focusColor, fontSize: 10),
                ),
              ),
            if (ad.numberOfRooms != null && ad.numberOfRooms! != 0)
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 8, start: 18),
                child: CustomWidgetColumn(
                  text: "${ad.numberOfRooms!} غرفة",
                  image: AppIcons.four,
                  // style: Styles.style8.copyWith(
                  //    color: Theme.of(context).focusColor, fontSize: 10),
                ),
              ),
            if (ad.numberOfBathrooms != null && ad.numberOfBathrooms! != 0)
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 8, start: 18),
                child: CustomWidgetColumn(
                  text: "${ad.numberOfBathrooms!} حمام",
                  image: AppIcons.five,
                  // style: Styles.style8.copyWith(
                  //    color: Theme.of(context).focusColor, fontSize: 10),
                ),
              ),
            if (ad.type != null && ad.type!.isNotEmpty)
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 8, start: 18),
                child: CustomWidgetColumn(
                  text: ad.type!,
                  image: AppIcons.carInfo,
                  // style: Styles.style8.copyWith(
                  //    color: Theme.of(context).focusColor, fontSize: 10),
                ),
              ),
            if (ad.fuelType != null && ad.fuelType!.isNotEmpty)
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 8, start: 18),
                child: CustomWidgetColumn(
                  text: "${ad.fuelType![0]} ",
                  image: AppIcons.fuel,
                  // style: Styles.style8.copyWith(
                  //    color: Theme.of(context).focusColor, fontSize: 10),
                ),
              ),
            if (ad.transmissionType != null && ad.transmissionType!.isNotEmpty)
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 8, start: 18),
                child: CustomWidgetColumn(
                  text: ad.transmissionType!,
                  image: AppIcons.gearBox,
                  // style: Styles.style8.copyWith(
                  //    color: Theme.of(context).focusColor, fontSize: 10),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          ad.description,
          textAlign: TextAlign.right,
          style: Styles.style8
              .copyWith(color: Theme.of(context).focusColor, fontSize: 12),
        ),
      ],
    );
  }
}
