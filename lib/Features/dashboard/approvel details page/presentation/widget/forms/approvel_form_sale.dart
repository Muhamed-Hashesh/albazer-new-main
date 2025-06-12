import 'package:albazar_app/Features/ads/data/models/ad.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/check_boxes_section.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/chip_section.dart';
import 'package:albazar_app/Features/dashboard/approvel%20details%20page/presentation/widget/custom_image_view.dart';
import 'package:albazar_app/Features/dashboard/approvel%20details%20page/presentation/widget/forms/approvel_form_cars.dart';
import 'package:flutter/material.dart';

class ApprovelFormSale extends StatefulWidget {
  final Ad ad;
  const ApprovelFormSale({super.key, required this.ad});

  @override
  State<ApprovelFormSale> createState() => _ApprovelFormSaleState();
}

class _ApprovelFormSaleState extends State<ApprovelFormSale> {
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _publishedViaController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _bathController = TextEditingController();
  final TextEditingController _roomController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _inOutController = TextEditingController();
  final TextEditingController _depoistController = TextEditingController();
  final TextEditingController _buildingAgeController = TextEditingController();
  final List<String> buildings = [
    "شقة",
    "فيلا",
    "بناء",
    "بيت عربى",

    // "بيت عربي",
    "محل",
    "مستودع",
    "مكتب",
    "مصنع",
    "مقهى",
  ];
  final List<String> luxuries = [
    "بلكون",
    "أجهزة المطبخ",
    "حديقة خاصة",
    "أمن",
    "موقف سيارات",
    "حمام سباحة",
    "تليفون أرضى",
  ];
  final List<String> furnitureChoices = [
    "نعم",
    "لا",
  ];
  final List<String> paymentMethods = [
    "كاش",
    "تقسيط",
    "كاش أو تقسيط",
  ];
  final List<String> deliveryTerms = [
    "بدون إكساء",
    "نص إكساء",
    "إكساء ديلوكس",
  ];
  final List<String> buildingStatus = [
    "جاهز",
    "قيد الإنشاء",
  ];

  @override
  void initState() {
    _priceController.text = widget.ad.price?.toString() ?? '';
    _publishedViaController.text = widget.ad.publishedVia?.toString() ?? '';
    _areaController.text = widget.ad.area?.toString() ?? '';
    _cityController.text = widget.ad.city?.toString() ?? '';
    _bathController.text = widget.ad.numberOfBathrooms?.toString() ?? '';
    _roomController.text = widget.ad.numberOfRooms?.toString() ?? '';
    _floorController.text = widget.ad.floor ?? '';
    _inOutController.text = widget.ad.regulationStatus ?? '';
    _depoistController.text = widget.ad.securityDeposit?.toString() ?? '';
    _buildingAgeController.text = widget.ad.year?.toString() ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _areaController.dispose();
    _cityController.dispose();
    _bathController.dispose();
    _roomController.dispose();
    _depoistController.dispose();
    _publishedViaController.dispose();
    _buildingAgeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
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
                textAlign: TextAlign.start,
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
            hintText: "المحافظة المدخلة",
            title: "المحافظة",
            controller: _cityController,
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
            hintText: "المساحة المدخلة",
            title: "المساحة (م)*",
            controller: _areaController,
          ),
          const SizedBox(
            height: 20,
          ),
          CustomRowApprovel(
            title: "السعر",
            hintText: "السعر المدخل SYP",
            controller: _priceController,
          ),
          const SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: SizedBox(
              width: 200,
              child: ChipSection(
                title: 'الكماليات',
                items: luxuries,
                selectedItems: widget.ad.amenities ?? [],
                onSelect: (luxury) {},
              ),
            ),
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
            hintText: 'الطابق',
            title: 'الطابق',
            controller: _floorController,
          ),
          const SizedBox(
            height: 20,
          ),
          CustomRowApprovel(
            hintText: 'عدد الغرف المدخلة',
            title: 'عدد الغرف',
            controller: _roomController,
          ),
          const SizedBox(
            height: 20,
          ),
          CustomRowApprovel(
            hintText: 'عدد الحمامات المدخلة',
            title: 'عدد الحمامات',
            controller: _bathController,
          ),
          const SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: ChipSection(
              title: 'الفرش',
              items: furnitureChoices,
              selectedItems: [
                widget.ad.furnishing == null
                    ? ''
                    : widget.ad.furnishing!
                        ? furnitureChoices.first
                        : furnitureChoices[1]
              ],
              onSelect: (choice) {},
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: CheckBoxesSection(
                title: 'طريقة الدفع',
                items: paymentMethods,
                selectedItems: [widget.ad.paymentMethod ?? ''],
                onChanged: (paymentMethod) {}),
          ),
          const SizedBox(
            height: 20,
          ),
          CheckBoxesSection(
              isList: true,
              title: 'شروط التسليم',
              items: deliveryTerms,
              selectedItems: [widget.ad.deliveryConditions ?? ''],
              onChanged: (deliveryTerm) {}),
          const SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: CheckBoxesSection(
                title: 'حالة العقار',
                items: buildingStatus,
                selectedItems: [widget.ad.propertyCondition ?? ''],
                onChanged: (status) {}),
          ),
        ],
      ),
    );
  }
}
