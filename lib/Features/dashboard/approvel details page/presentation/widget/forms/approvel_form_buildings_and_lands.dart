import 'dart:developer';

import 'package:albazar_app/Features/ads/data/models/ad.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/check_boxes_section.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/custom_check_box.dart';
import 'package:albazar_app/Features/dashboard/approvel%20details%20page/presentation/widget/custom_image_view.dart';
import 'package:albazar_app/Features/dashboard/approvel%20details%20page/presentation/widget/forms/approvel_form_cars.dart';
import 'package:flutter/material.dart';

class ApprovelFormBuildingsAndLands extends StatefulWidget {
  final Ad ad;
  const ApprovelFormBuildingsAndLands({super.key, required this.ad});

  @override
  State<ApprovelFormBuildingsAndLands> createState() =>
      _ApprovelFormBuildingsAndLandsState();
}

class _ApprovelFormBuildingsAndLandsState
    extends State<ApprovelFormBuildingsAndLands> {
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _publishedViaController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _inOutController = TextEditingController();
  final TextEditingController _depositController = TextEditingController();
  final List<String> paymentMethods = [
    "كاش",
    "تقسيط",
    "كاش أو تقسيط",
  ];
  final List<String> typeOfSale = [
    "بيع",
    "إيجار",
  ];
  final List<String> type = [
    "زراعية",
    "تجارية",
    "صناعية",
    "سكنية",
  ];

  @override
  void initState() {
    _areaController.text = widget.ad.area?.toString() ?? '';
    _publishedViaController.text = widget.ad.publishedVia?.toString() ?? '';
    _cityController.text = widget.ad.city?.toString() ?? '';
    _priceController.text = widget.ad.price?.toString() ?? '';
    _depositController.text = widget.ad.downPayment?.toString() ?? '';
    _floorController.text = widget.ad.floor ?? '';
    _inOutController.text = widget.ad.regulationStatus ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _areaController.dispose();
    _priceController.dispose();
    _depositController.dispose();
    _floorController.dispose();
    _publishedViaController.dispose();
    _inOutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('*****${widget.ad.listingstatus}');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomImageView(
                images: widget.ad.images!,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                widget.ad.adTitle,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Theme.of(context).hoverColor,
                  fontSize: 21.19,
                  fontFamily: 'Noor',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.ad.description,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Theme.of(context).hoverColor,
                  fontSize: 10.59,
                  fontFamily: 'Noor',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          CustomRowApprovel(
            hintText: 'التنظيم',
            title: 'التنظيم',
            controller: _inOutController,
          ),
          const SizedBox(
            height: 20,
          ),
          CustomRowApprovel(
            hintText: "من قبل",
            title: "من قبل",
            controller: _publishedViaController,
          ),
          const SizedBox(
            height: 10,
          ),
          CustomRowApprovel(
            hintText: 'الطابق',
            title: 'الطابق',
            controller: _floorController,
          ),
          const SizedBox(
            height: 20,
          ),
          CustomRowApprovel(
            hintText: "المحافظة المدخلة",
            title: "المحافظة",
            controller: _cityController,
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 230,
            child: CheckBoxesSection(
                title: "النوع",
                selectedItems: [widget.ad.propertyType ?? ''],
                items: type,
                onChanged: (status) {}),
          ),
          const SizedBox(
            height: 20,
          ),
          CustomRowApprovel(
            hintText: "المساحة المدخلة",
            title: "المساحة (م)*",
            controller: _areaController,
          ),
          const SizedBox(
            height: 20,
          ),
          CustomRowApprovel(
            hintText: "السعر المدخل",
            title: "السعر",
            controller: _priceController,
          ),
          const SizedBox(
            height: 20,
          ),
          CustomCheckBox(
            text: "قابل للتفاوض",
            isChecked: widget.ad.negotiable ?? false,
            onChanged: (value) {},
          ),
          const SizedBox(
            height: 20,
          ),
          CheckBoxesSection(
              title: 'طريقة الدفع',
              items: paymentMethods,
              selectedItems: [widget.ad.paymentMethod ?? ''],
              onChanged: (paymentMethod) {}),
          const SizedBox(
            height: 20,
          ),
          CheckBoxesSection(
              title: 'بيع/ايجار',
              items: typeOfSale,
              selectedItems: [widget.ad.listingstatus ?? ''],
              onChanged: (typeOfSale) {}),
        ],
      ),
    );
  }
}
