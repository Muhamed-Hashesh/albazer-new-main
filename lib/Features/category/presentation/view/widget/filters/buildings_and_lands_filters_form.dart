import 'package:albazar_app/Features/ads/presentation/widgets/check_boxes_section.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/chip_section.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/custom_check_box.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/number_field.dart';
import 'package:albazar_app/core/utils/constants.dart';
import 'package:albazar_app/core/widgets/custom_drob_down.dart';
import 'package:flutter/material.dart';

class BuildingsAndLandsFiltersForm extends StatefulWidget {
  final Map<String, dynamic>? filters;
  const BuildingsAndLandsFiltersForm({super.key, this.filters});

  @override
  State<BuildingsAndLandsFiltersForm> createState() =>
      BuildingsAndLandsFiltersFormState();
}

class BuildingsAndLandsFiltersFormState
    extends State<BuildingsAndLandsFiltersForm> {
  final TextEditingController _areaFromController = TextEditingController(),
      _areaToController = TextEditingController(),
      _priceFromController = TextEditingController(),
      _priceToController = TextEditingController(),
      _nameController = TextEditingController(),
      _cityController = TextEditingController(),
      _currencyController = TextEditingController();
  String? _selectedCity;
  String _dollarOrLeraa = 'ليره';
  String _selectedLandType = '',
      _selectedSaleOrRent = '',
      _selectedContactMethod = '',
      _publishedVia = '',
      _selectedLocation = '';
  bool isChecked = false;

  final List<String> landTypes = [
    "زراعى",
    "تجارى",
    "صناعى",
    "سكنى",
  ];
  final List<String> furnitureChoices = [
    "نعم",
    "لا",
  ];
  final List<String> rentRates = [
    "يوميا",
    "اسبوعيا",
    "شهريا",
  ];

  final List<String> saleOrRentChoices = [
    "بيع",
    "إيجار",
  ];
  final List<String> buildingStatus = [
    "جاهز",
    "قيد الإنشاء",
  ];
  final List<String> deliveryTerms = [
    "متشطب",
    "بدون تشطيب",
    "نصف تشطيب",
  ];
  final List<String> typeLocation = [
    "داخل تنظيم",
    "خارج تنظيم",
  ];
  final List<String> isOwner = [
    "المالك",
    "وكيل",
  ];
  final List<String> contactMethods = [
    "كاش",
    "تقسيط",
    "كاش أو تقسيط",
  ];

  @override
  void initState() {
    _selectedLandType = widget.filters?["property type"] ?? '';
    _selectedLocation = widget.filters?["regulationStatus"] ?? '';
    _selectedSaleOrRent = widget.filters?["listing status"] ?? '';
    _publishedVia = widget.filters?["publishedVia"] ?? '';
    _areaFromController.text = widget.filters?["area[gte]"]?.toString() ?? '';
    _areaToController.text = widget.filters?["area[lte]"]?.toString() ?? '';
    _priceFromController.text = widget.filters?["price[gte]"]?.toString() ?? '';
    _priceToController.text = widget.filters?["price[lte]"]?.toString() ?? '';
    _cityController.text = widget.filters?["city"]?.toString() ?? '';
    _currencyController.text = widget.filters?["currency"]?.toString() ?? '';
    super.initState();
  }

  Map<String, dynamic> search() => {
        if (_selectedLandType.isNotEmpty) "property type": _selectedLandType,
        if (_selectedLocation.isNotEmpty) "regulationStatus": _selectedLocation,
        if (_selectedSaleOrRent.isNotEmpty)
          "listing status": _selectedSaleOrRent,
        if (_publishedVia.isNotEmpty) "publishedVia": _publishedVia,
        if (_areaFromController.text.trim().isNotEmpty)
          "area[gte]": num.parse(_areaFromController.text.trim()),
        if (_areaToController.text.trim().isNotEmpty)
          "area[lte]": num.parse(_areaToController.text.trim()),
        if (_priceFromController.text.trim().isNotEmpty)
          "price[gte]": num.parse(_priceFromController.text.trim()),
        if (_priceToController.text.trim().isNotEmpty)
          "price[lte]": num.parse(_priceToController.text.trim()),
        if (_cityController.text.trim().isNotEmpty)
          "city": _cityController.text.trim(),
        if (_currencyController.text.trim().isNotEmpty)
          "currency": _currencyController.text.trim(),
      };

  @override
  void dispose() {
    _areaFromController.dispose();
    _areaToController.dispose();
    _priceToController.dispose();
    _cityController.dispose();
    _currencyController.dispose();
    _priceFromController.dispose();
    _nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      cacheExtent: 10000,
      children: [
        Text(
          'المحافظة',
          style: TextStyle(
            color: Theme.of(context).focusColor,
            fontSize: 16,
            fontFamily: 'Noor',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        CustomDropdown(
            selectedValue: _selectedCity,
            // label: 'المحافظة',
            hint: 'اختر المحافظة',
            options: AppConstants.cityLists,
            onChanged: (city) {
              setState(() {
                _selectedCity = city!;
                _cityController.text = city;
              });
            }),
        const SizedBox(
          height: 20,
        ),
        CheckBoxesSection(
          title: "داخل / خارج تنظيم",
          selectedItems: [_selectedLocation],
          items: typeLocation,
          onChanged: (status) {
            setState(() {
              if (_selectedLocation == status) {
                _selectedLocation = '';
                return;
              }
              _selectedLocation = status;
            });
          },
        ),
        const SizedBox(
          height: 20,
        ),
        CheckBoxesSection(
            title: 'تم النشر من قبل ',
            items: isOwner,
            selectedItems: [_publishedVia],
            onChanged: (status) {
              setState(() {
                if (_publishedVia == status) {
                  _publishedVia = '';
                  return;
                }
                _publishedVia = status;
              });
            }),
        const SizedBox(
          height: 25,
        ),
        CheckBoxesSection(
            title: 'النوع',
            items: landTypes,
            selectedItems: [_selectedLandType],
            onChanged: (landType) {
              setState(() {
                if (_selectedLandType == landType) {
                  _selectedLandType = '';
                  return;
                }
                _selectedLandType = landType;
              });
            }),
        const SizedBox(
          height: 25,
        ),
        Text(
          'المساحة (م٢)*',
          style: TextStyle(
            color: Theme.of(context).focusColor,
            fontSize: 16,
            fontFamily: 'Noor',
            fontWeight: FontWeight.w700,
          ),
        ),
        Row(
          children: [
            NumberField(
              isExpanded: true,
              controller: _areaFromController,
              title: 'من',
              metric: 'sqft',
            ),
            const SizedBox(
              width: 10,
            ),
            NumberField(
              isExpanded: true,
              controller: _areaToController,
              title: 'إلى',
              metric: 'sqft',
            ),
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        Text(
          "العملة",
          style: TextStyle(
            color: Theme.of(context).focusColor,
            fontSize: 16,
            fontFamily: 'Noor',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        CustomDropdown(
            selectedValue: _dollarOrLeraa,
            // label: 'العملة',
            hint: "اختر العملة",
            options: const ['دولار', 'ليره'],
            onChanged: (curruncy) {
              setState(() {
                _dollarOrLeraa = curruncy!;
                _currencyController.text = curruncy;
              });
            }),
        const SizedBox(
          height: 25,
        ),
        Text(
          'السعر',
          style: TextStyle(
            color: Theme.of(context).focusColor,
            fontSize: 16,
            fontFamily: 'Noor',
            fontWeight: FontWeight.w700,
          ),
        ),
        Row(
          children: [
            NumberField(
              isExpanded: true,
              controller: _priceFromController,
              title: 'من',
              metric: _dollarOrLeraa == 'دولار' ? "USD" : 'SYP',
            ),
            const SizedBox(
              width: 10,
            ),
            NumberField(
              isExpanded: true,
              controller: _priceToController,
              title: 'إلى',
              metric: _dollarOrLeraa == 'دولار' ? "USD" : 'SYP',
            ),
          ],
        ),
        CustomCheckBox(
          text: "قابل للتفاوض",
          isChecked: isChecked,
          onChanged: (value) {
            setState(() {
              if (isChecked == value) {
                isChecked = true;
                return;
              }
              isChecked = value!;
            });
          },
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'المقدم',
          style: TextStyle(
            color: Theme.of(context).focusColor,
            fontSize: 16,
            fontFamily: 'Noor',
            fontWeight: FontWeight.w700,
          ),
        ),
        Row(
          children: [
            NumberField(
              isExpanded: true,
              controller: _priceFromController,
              title: 'من',
              metric: _dollarOrLeraa == 'دولار' ? "USD" : 'SYP',
            ),
            const SizedBox(
              width: 10,
            ),
            NumberField(
              isExpanded: true,
              controller: _priceToController,
              title: 'إلى',
              metric: _dollarOrLeraa == 'دولار' ? "USD" : 'SYP',
            ),
          ],
        ),
        CheckBoxesSection(
            title: 'طريقة الدفع',
            items: contactMethods,
            selectedItems: [_selectedContactMethod],
            onChanged: (contactMethod) {
              setState(() {
                if (_selectedContactMethod == contactMethod) {
                  _selectedContactMethod = '';
                  return;
                }
                _selectedContactMethod = contactMethod;
              });
            }),
        const SizedBox(
          height: 25,
        ),
        ChipSection(
          title: 'بيع/إيجار',
          items: saleOrRentChoices,
          selectedItems: [_selectedSaleOrRent],
          onSelect: (choice) {
            setState(() {
              if (_selectedSaleOrRent == choice) {
                _selectedSaleOrRent = '';
                return;
              }
              _selectedSaleOrRent = choice;
            });
          },
        ),
      ],
    );
  }
}
