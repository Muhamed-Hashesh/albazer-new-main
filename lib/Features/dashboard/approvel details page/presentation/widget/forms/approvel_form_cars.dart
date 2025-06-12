import 'package:albazar_app/Features/ads/data/models/ad.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/check_boxes_section.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/custom_check_box.dart';
import 'package:albazar_app/Features/dashboard/approvel%20details%20page/presentation/widget/custom_image_view.dart';
import 'package:albazar_app/core/widgets/fields/custom_labeled_text_field.dart';
import 'package:flutter/material.dart';

class ApprovelFormCars extends StatefulWidget {
  final Ad ad;
  const ApprovelFormCars({super.key, required this.ad});

  @override
  State<ApprovelFormCars> createState() => _ApprovelFormCarsState();
}

class _ApprovelFormCarsState extends State<ApprovelFormCars> {
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _publishedViaController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _kilometersController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _seatsController = TextEditingController();
  final TextEditingController _doorsController = TextEditingController();
  final TextEditingController _innerPartController = TextEditingController();
  final TextEditingController _virsionController = TextEditingController();
  final TextEditingController _saleOrRentController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _startPriceController = TextEditingController();
  final List<String> paymentMethods = [
    "كاش",
    "تقسيط",
    "كاش أو تقسيط",
  ];
  final List<String> typeOfSale = [
    "بيع",
    "ايجار",
  ];
  final List<String> type = [
    "زراعى",
    "تجارى",
    "صناعى",
    "سكنى",
  ];
  final List<String> addOns = [
    "وسائد هوائية",
    "راديو",
    "نوافذ كهربائية",
    "مرايا كهربائية",
    "نظام بلوتوث",
    "شاحن يو اس بي",
  ];
  final List<String> fuelTypes = [
    "البنزين",
    "كهرباء",
    "غاز طبيعى",
    "ديزل",
  ];
  final List<String> transmissions = [
    "اتوماتيك",
    "يدوى/عادى",
  ];

  @override
  void initState() {
    _brandController.text = widget.ad.brand ?? '';
    _publishedViaController.text = widget.ad.publishedVia ?? '';
    _priceController.text = widget.ad.price?.toString() ?? '';
    _kilometersController.text = widget.ad.kilometers?.toString() ?? '';
    _descriptionController.text = widget.ad.description;
    _cityController.text = widget.ad.city ?? '';
    _colorController.text = widget.ad.color ?? '';
    _typeController.text = widget.ad.type ?? '';
    _virsionController.text = widget.ad.version ?? '';
    _saleOrRentController.text = widget.ad.listingstatus ?? '';
    _seatsController.text = widget.ad.seats ?? '';
    _doorsController.text = widget.ad.doors ?? '';
    _innerPartController.text = widget.ad.innerpart ?? '';
    _modelController.text = widget.ad.year ?? '';
    _startPriceController.text = widget.ad.downPayment ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _brandController.dispose();
    _priceController.dispose();
    _kilometersController.dispose();
    _descriptionController.dispose();
    _cityController.dispose();
    _colorController.dispose();
    _typeController.dispose();
    _virsionController.dispose();
    _saleOrRentController.dispose();
    _seatsController.dispose();
    _doorsController.dispose();
    _innerPartController.dispose();
    _modelController.dispose();
    _publishedViaController.dispose();
    _startPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                style: const TextStyle(
                  color: Color(0xFF1D1D1B),
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
                style: const TextStyle(
                  color: Color(0xFF1D1D1B),
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
            height: 10,
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
            title: "ماركة",
            hintText: "ماركة المدخلة",
            controller: _brandController,
          ),
          const SizedBox(
            height: 10,
          ),
          CustomRowApprovel(
            title: "النسحة",
            hintText: "النسخة المدخلة",
            controller: _virsionController,
          ),
          const SizedBox(
            height: 10,
          ),
          CustomRowApprovel(
            title: "اللون",
            hintText: "اللون المدخل",
            controller: _colorController,
          ),
          const SizedBox(
            height: 10,
          ),
          CustomRowApprovel(
            title: "بيع/إيجار",
            hintText: "بيع/إيجار",
            controller: _saleOrRentController,
          ),
          const SizedBox(
            height: 10,
          ),
          CustomRowApprovel(
            title: "الحالة",
            hintText: "الحالة المدخلة",
            controller: _typeController,
          ),
          const SizedBox(
            height: 10,
          ),
          CustomRowApprovel(
            title: "عدد المقاعد",
            hintText: "عدد المقاعد المدخل",
            controller: _seatsController,
          ),
          const SizedBox(
            height: 10,
          ),
          CustomRowApprovel(
            title: "عدد الابواب",
            hintText: "عدد الابواب المدخل",
            controller: _doorsController,
          ),
          const SizedBox(
            height: 10,
          ),
          CustomRowApprovel(
            title: "الجزء الداخلى",
            hintText: "الجزء الداخلى",
            controller: _innerPartController,
          ),
          const SizedBox(
            height: 10,
          ),
          CustomRowApprovel(
            title: "السعر",
            hintText: "السعر المدخل SYP",
            controller: _priceController,
          ),
          const SizedBox(
            height: 10,
          ),
          CustomCheckBox(
            text: "قابل للتفاوض",
            isChecked: widget.ad.negotiable ?? false,
            onChanged: (value) {},
          ),
          const SizedBox(
            height: 20,
          ),
          CustomRowApprovel(
            title: "كيلومترات",
            hintText: "المساحة المدخلة sqft",
            controller: _kilometersController,
          ),
          const SizedBox(
            height: 10,
          ),
          CustomRowApprovel(
            title: "موديل",
            hintText: "موديل المدخل",
            controller: _modelController,
          ),
          const SizedBox(
            height: 10,
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
              title: 'إضافات',
              isList: true,
              items: addOns,
              selectedItems: widget.ad.additionalFeatures ?? [],
              onChanged: (addOn) {}),
          const SizedBox(
            height: 25,
          ),
          CheckBoxesSection(
              title: 'نوع الوقود',
              isList: true,
              items: fuelTypes,
              selectedItems: widget.ad.fuelType ?? [],
              onChanged: (fuelType) {}),
          const SizedBox(
            height: 25,
          ),
          CheckBoxesSection(
              title: 'ناقل الحركة',
              isList: true,
              items: transmissions,
              selectedItems: [widget.ad.transmissionType ?? ''],
              onChanged: (transmission) {}),
          const SizedBox(
            height: 20,
          ),
          CustomLabeledTextField(
            controller: _descriptionController,
            validator: (description) {
              if (description!.isEmpty) {
                return 'من فضلك ادخل وصف الاعلان';
              }
              return null;
            },
            label: 'المزيد من التفاصيل الفنية',
            hint: "تفاصيل مدخلة....",
            maxLines: 4,
          ),
        ],
      ),
    );
  }
}

class CustomRowApprovel extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController controller;
  const CustomRowApprovel({
    super.key,
    required this.title,
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).hoverColor,
            fontSize: 17.66,
            fontFamily: 'Noor',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: TextField(
          controller: controller,
          decoration: InputDecoration(
            fillColor: Theme.of(context).highlightColor,
            filled: true,
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color(0xFF8C8C8C),
              fontSize: 13,
              fontFamily: 'Noor',
              fontWeight: FontWeight.w400,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                color: Theme.of(context).highlightColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).highlightColor,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ))
      ],
    );
  }
}
