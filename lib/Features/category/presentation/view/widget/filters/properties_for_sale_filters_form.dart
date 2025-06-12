import 'package:albazar_app/Features/ads/presentation/widgets/check_boxes_section.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/chip_section.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/custom_check_box.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/number_field.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/numbers_section.dart';
import 'package:albazar_app/core/utils/constants.dart';
import 'package:albazar_app/core/widgets/custom_drob_down.dart';
import 'package:albazar_app/core/widgets/fields/custom_labeled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PropertiesForSaleFiltersForm extends StatefulWidget {
  final Map<String, dynamic>? filters;
  const PropertiesForSaleFiltersForm({super.key, this.filters});

  @override
  State<PropertiesForSaleFiltersForm> createState() =>
      PropertiesForSaleFiltersFormState();
}

class PropertiesForSaleFiltersFormState
    extends State<PropertiesForSaleFiltersForm> {
  final TextEditingController _areaFromController = TextEditingController(),
      _areaToController = TextEditingController(),
      _locationController = TextEditingController(),
      _priceFromController = TextEditingController(),
      _priceToController = TextEditingController(),
      _providedFromController = TextEditingController(),
      _providedToController = TextEditingController(),
      _insuranceController = TextEditingController(),
      _cityController = TextEditingController(),
      _floorController = TextEditingController(),
      _buildingAgeontroller = TextEditingController(),
      _currencyController = TextEditingController();
  String? _selectedCity;
  String _dollarOrLeraa = 'ليره';
  String _selectedBuilding = '',
      _selectedRentRate = '',
      _selectedChoice = '',
      _selectedLocation = '',
      _publishedVia = '',
      _selectedType = '',
      _selectedBuildingStatus = '',
      _selectedContactMethod = '',
      _selectedDeliveryTerm = '';
  final List<String> _selectedLuxuries = [];
  bool isChecked = false;

  int _selectedRoom = 0, _selectedBathroom = 0;

  final List<String> buildingStatus = [
    "جاهز",
    "قيد الإنشاء",
  ];
  final List<String> typeLocation = [
    "داخل تنظيم",
    "خارج تنظيم",
  ];
  final List<String> isOwner = [
    "المالك",
    "وكيل",
  ];
  final List<String> deliveryTerms = [
    "بدون اكساء",
    "نص اكساء",
    "اكساء ديلوكسى",
  ];

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
  final List<String> furnitureChoices = [
    "نعم",
    "لا",
  ];
  final List<String> rentRates = [
    "يوميا",
    "اسبوعيا",
    "شهريا",
  ];
  final List<String> types = [
    "سكنى",
    "تجارى",
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
  final List<String> contactMethods = [
    "كاش",
    "تقسيط",
    "كاش أو تقسيط",
  ];

  @override
  void initState() {
    super.initState();
    _selectedBuilding = widget.filters?["property type"] ?? '';
    _selectedRentRate = widget.filters?["rent rate"] ?? '';
    _areaFromController.text = widget.filters?["area[gte]"]?.toString() ?? '';
    _areaToController.text = widget.filters?["area[lte]"]?.toString() ?? '';
    _priceFromController.text = widget.filters?["price[gte]"]?.toString() ?? '';
    _priceToController.text = widget.filters?["price[lte]"]?.toString() ?? '';
    _providedFromController.text =
        widget.filters?["down payment[gte]"]?.toString() ?? '';
    _providedToController.text =
        widget.filters?["down payment[lte]"]?.toString() ?? '';
    _selectedRoom = widget.filters?["number of rooms"] ?? 0;
    _selectedLocation = widget.filters?["regulationStatus"] ?? '';
    _publishedVia = widget.filters?["publishedVia"] ?? '';
    _selectedBathroom = widget.filters?["number of bathrooms"] ?? 0;
    _buildingAgeontroller.text = widget.filters?["building age"] ?? '';
    _cityController.text = widget.filters?["city"]?.toString() ?? '';
    _floorController.text = widget.filters?["floor"]?.toString() ?? '';
    _currencyController.text = widget.filters?["currency"]?.toString() ?? '';
    _selectedChoice = widget.filters?["furnishing"] == null
        ? ''
        : (widget.filters?["furnishing"]
            ? furnitureChoices.first
            : furnitureChoices[1]);

    if (widget.filters?["amenities"] != null) {
      _selectedLuxuries.add(widget.filters?["amenities"]);
    }

    _selectedDeliveryTerm = widget.filters?["delivery conditions"] ?? '';
    _selectedBuildingStatus = widget.filters?["property condition"] ?? '';
  }

  Map<String, dynamic> search() => {
        if (_selectedBuilding.isNotEmpty) "property type": _selectedBuilding,
        if (_selectedRentRate.isNotEmpty) "rent rate": _selectedRentRate,
        if (_selectedChoice.isNotEmpty)
          "furnishing": _selectedChoice == furnitureChoices.first,
        if (_selectedLuxuries.isNotEmpty) "amenities": _selectedLuxuries.first,
        if (_selectedBuildingStatus.isNotEmpty)
          "property condition": _selectedBuildingStatus,
        if (_selectedDeliveryTerm.isNotEmpty)
          "delivery conditions": _selectedDeliveryTerm,
        if (_selectedRoom > 0) "number of rooms": _selectedRoom,
        if (_selectedLocation.isNotEmpty) "regulationStatus": _selectedLocation,
        if (_publishedVia.isEmpty) "publishedVia": _publishedVia,
        if (_selectedBathroom > 0) "number of bathrooms": _selectedBathroom,
        if (_floorController.text.trim().isNotEmpty)
          "floor": _floorController.text.trim(),
        if (_areaToController.text.trim().isNotEmpty)
          "area[lte]": num.parse(_areaToController.text.trim()),
        if (_priceFromController.text.trim().isNotEmpty)
          "price[gte]": num.parse(_priceFromController.text.trim()),
        if (_priceToController.text.trim().isNotEmpty)
          "price[lte]": num.parse(_priceToController.text.trim()),
        if (_providedFromController.text.trim().isNotEmpty)
          "down payment[gte]": num.parse(_providedFromController.text.trim()),
        if (_providedToController.text.trim().isNotEmpty)
          "down payment[lte]": num.parse(_providedToController.text.trim()),
        if (_buildingAgeontroller.text.trim().isNotEmpty)
          "building age": _buildingAgeontroller.text.trim(),
        if (_cityController.text.trim().isNotEmpty)
          "city": _cityController.text.trim(),
        if (_currencyController.text.trim().isNotEmpty)
          "currency": _currencyController.text.trim(),
      };

  @override
  void dispose() {
    _areaFromController.dispose();
    _areaToController.dispose();
    _priceFromController.dispose();
    _priceToController.dispose();
    _providedFromController.dispose();
    _providedToController.dispose();
    _locationController.dispose();
    _insuranceController.dispose();
    _cityController.dispose();
    _buildingAgeontroller.dispose();
    _currencyController.dispose();
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
            title: "الفئة",
            selectedItems: [_selectedType],
            items: types,
            onChanged: (status) {
              setState(() {
                if (_selectedType == status) {
                  _selectedType = '';
                  return;
                }
                _selectedType = status;
              });
            }),
        const SizedBox(
          height: 10,
        ),
        CheckBoxesSection(
            title: 'نوع العقار',
            items: buildings,
            selectedItems: [_selectedBuilding],
            onChanged: (building) {
              setState(() {
                if (_selectedBuilding == building) {
                  _selectedBuilding = '';
                  return;
                }
                _selectedBuilding = building;
              });
            }),
        const SizedBox(
          height: 10,
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
              title: '',
              metric: 'sqft',
            ),
            const SizedBox(
              width: 10,
            ),
            NumberField(
              isExpanded: true,
              controller: _areaToController,
              title: '',
              metric: 'sqft',
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        CustomLabeledTextField(
          controller: _floorController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (insurance) {
            if (insurance!.isEmpty) {
              return 'ادخل الطابق';
            }
            return null;
          },
          label: 'الطابق',
          hint: "أدخل الطابق",
        ),
        const SizedBox(
          height: 10,
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
        const SizedBox(
          height: 10,
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
          height: 10,
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
              controller: _providedFromController,
              title: 'من',
              metric: _dollarOrLeraa == 'دولار' ? "USD" : 'SYP',
            ),
            const SizedBox(
              width: 10,
            ),
            NumberField(
              isExpanded: true,
              controller: _providedToController,
              title: 'إلى',
              metric: _dollarOrLeraa == 'دولار' ? "USD" : 'SYP',
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        ChipSection(
          title: 'الكماليات',
          items: luxuries,
          selectedItems:
              _selectedLuxuries.isEmpty ? [] : [_selectedLuxuries.first],
          onSelect: (luxury) {
            setState(() {
              if (_selectedLuxuries.contains(luxury)) {
                _selectedLuxuries.remove(luxury);
              } else {
                _selectedLuxuries.clear();
                _selectedLuxuries.add(luxury);
              }
            });
          },
        ),
        const SizedBox(
          height: 10,
        ),
        NumbersSection(
          title: 'عدد الغرف',
          maxNumbers: 7,
          selectedNumber: _selectedRoom,
          onSelect: (room) {
            setState(() {
              _selectedRoom = room;
            });
          },
        ),
        const SizedBox(
          height: 10,
        ),
        NumbersSection(
          title: 'عدد الحمامات',
          maxNumbers: 7,
          selectedNumber: _selectedBathroom,
          onSelect: (bathroom) {
            setState(() {
              _selectedBathroom = bathroom;
            });
          },
        ),
        const SizedBox(
          height: 10,
        ),
        ChipSection(
          title: 'الفرش',
          items: furnitureChoices,
          selectedItems: [_selectedChoice],
          onSelect: (choice) {
            setState(() {
              if (_selectedChoice == choice) {
                _selectedChoice = '';
                return;
              }
              _selectedChoice = choice;
            });
          },
        ),
        const SizedBox(
          height: 25,
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
          height: 10,
        ),
        CheckBoxesSection(
            isList: true,
            title: 'شروط التسليم',
            items: deliveryTerms,
            selectedItems: [_selectedDeliveryTerm],
            onChanged: (deliveryTerm) {
              setState(() {
                if (_selectedDeliveryTerm == deliveryTerm) {
                  _selectedDeliveryTerm = '';
                  return;
                }
                _selectedDeliveryTerm = deliveryTerm;
              });
            }),
        const SizedBox(
          height: 10,
        ),
        const SizedBox(
          height: 25,
        ),
        CustomLabeledTextField(
          controller: _buildingAgeontroller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (insurance) {
            if (insurance!.isEmpty) {
              return 'ادخل عمر المبنى';
            }
            return null;
          },
          label: 'عمر المبنى',
          hint: "أدخل عمر المبنى",
        ),
        const SizedBox(
          height: 25,
        ),
        CheckBoxesSection(
            title: 'حالة العقار',
            items: buildingStatus,
            selectedItems: [_selectedBuildingStatus],
            onChanged: (status) {
              setState(() {
                if (_selectedBuildingStatus == status) {
                  _selectedBuildingStatus = '';
                  return;
                }
                _selectedBuildingStatus = status;
              });
            }),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
