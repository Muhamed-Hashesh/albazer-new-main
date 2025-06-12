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

class PropertiesForRentFiltersForm extends StatefulWidget {
  final Map<String, dynamic>? filters;
  const PropertiesForRentFiltersForm({super.key, this.filters});

  @override
  State<PropertiesForRentFiltersForm> createState() =>
      PropertiesForRentFiltersFormState();
}

class PropertiesForRentFiltersFormState
    extends State<PropertiesForRentFiltersForm> {
  final TextEditingController _areaFromController = TextEditingController(),
      _areaToController = TextEditingController(),
      _floorController = TextEditingController(),
      _locationController = TextEditingController(),
      _feesFromController = TextEditingController(),
      _feesToController = TextEditingController(),
      _insuranceController = TextEditingController(),
      _cityController = TextEditingController(),
      _buildingAgeontroller = TextEditingController(),
      _currencyController = TextEditingController();
  String? _selectedCity;
  String _dollarOrLeraa = 'ليره';

  String _selectedBuilding = '',
      _selectedRentRate = '',
      _selectedLocation = '',
      _publishedVia = '',
      _selectedType = '',
      _selectedChoice = '';
  final List<String> _selectedLuxuries = [];
  bool isChecked = false;

  int _selectedRoom = 0, _selectedBathroom = 0;

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
  final List<String> isOwner = [
    "المالك",
    "وكيل",
  ];
  final List<String> rentRates = [
    "يوميا",
    "اسبوعيا",
    "شهريا",
  ];

  final List<String> luxuries = [
    "شرفة",
    "أجهزة المطبخ",
    "حديقة خاصة",
    "أمن",
    "موقف سيارات",
    "حمام سباحة",
    "تليفون أرضى",
  ];
  final List<String> typeLocation = [
    "داخل تنظيم",
    "خارج تنظيم",
  ];
  final List<String> types = [
    "سكني",
    "تجاري",
  ];

  @override
  void initState() {
    _selectedLocation = widget.filters?["regulationStatus"] ?? '';
    _publishedVia = widget.filters?["publishedVia"] ?? '';
    _selectedBuilding = widget.filters?["property type"] ?? '';
    _selectedRentRate = widget.filters?["rent rate"] ?? '';
    _areaFromController.text = widget.filters?["area[gte]"]?.toString() ?? '';
    _areaToController.text = widget.filters?["area[lte]"]?.toString() ?? '';
    _floorController.text = widget.filters?["floor"]?.toString() ?? '';
    _feesFromController.text =
        widget.filters?["rental fees[gte]"]?.toString() ?? '';
    _feesToController.text =
        widget.filters?["rental fees[lte]"]?.toString() ?? '';
    _selectedRoom = widget.filters?["number of rooms"] ?? 0;
    _selectedBathroom = widget.filters?["number of bathrooms"] ?? 0;
    _buildingAgeontroller.text = widget.filters?["building age"] ?? '';
    _cityController.text = widget.filters?["city"]?.toString() ?? '';
    _currencyController.text = widget.filters?["currency"]?.toString() ?? '';
    _selectedChoice = widget.filters?["furnishing"] == null
        ? ''
        : (widget.filters?["furnishing"]
            ? furnitureChoices.first
            : furnitureChoices[1]);
    if (widget.filters?["amenities"] != null) {
      _selectedLuxuries.add(widget.filters?["amenities"]);
    }
    super.initState();
  }

  Map<String, dynamic> search() => {
        if (_selectedBuilding.isNotEmpty) "property type": _selectedBuilding,
        if (_publishedVia.isNotEmpty) "publishedVia": _publishedVia,
        if (_selectedRentRate.isNotEmpty) "rent rate": _selectedRentRate,
        if (_selectedLocation.isNotEmpty) "regulationStatus": _selectedLocation,
        if (_selectedChoice.isNotEmpty)
          "furnishing": _selectedChoice == furnitureChoices.first,
        if (_selectedLuxuries.isNotEmpty) "amenities": _selectedLuxuries.first,
        if (_selectedRoom > 0) "number of rooms": _selectedRoom,
        if (_selectedBathroom > 0) "number of bathrooms": _selectedBathroom,
        if (_floorController.text.trim().isNotEmpty)
          "floor": _floorController.text.trim(),
        if (_areaFromController.text.trim().isNotEmpty)
          "area[gte]": num.parse(_areaFromController.text.trim()),
        if (_areaToController.text.trim().isNotEmpty)
          "area[lte]": num.parse(_areaToController.text.trim()),
        if (_feesFromController.text.trim().isNotEmpty)
          "rental fees[gte]": num.parse(_feesFromController.text.trim()),
        if (_feesToController.text.trim().isNotEmpty)
          "rental fees[lte]": num.parse(_feesToController.text.trim()),
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
    _floorController.dispose();
    _feesToController.dispose();
    _locationController.dispose();
    _insuranceController.dispose();
    _feesFromController.dispose();
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
        // const CustomLabeledTextField(
        //   label: "الموقع",
        //   hint: "ابحث عن مدينة او منطقة ...",
        //   suffix: Icon(Icons.location_on_outlined),
        // ),
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
        // CustomDropdown(
        //     selectedValue: _selectedCity,
        //     label: 'المحافظة',
        //     options: cityLists,
        //     onChanged: (city) {
        //       setState(() {
        //         _selectedCity = city!;
        //       });
        //     }),
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
            hint: 'العملة',
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
          'رسوم الإيجار',
          style: TextStyle(
            color: Theme.of(context).focusColor,
            fontSize: 16,
            fontFamily: 'Noor',
            fontWeight: FontWeight.w600,
          ),
        ),
        Row(
          children: [
            NumberField(
              isExpanded: true,
              controller: _feesFromController,
              title: "من",
              metric: _dollarOrLeraa == 'دولار' ? "USD" : 'SYP',
            ),
            const SizedBox(
              width: 10,
            ),
            NumberField(
              isExpanded: true,
              controller: _feesToController,
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
          height: 20,
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
          height: 25,
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
          height: 25,
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
            title: 'معدل الايجار',
            items: rentRates,
            selectedItems: [_selectedRentRate],
            onChanged: (rentRate) {
              setState(() {
                if (_selectedRentRate == rentRate) {
                  _selectedRentRate = '';
                  return;
                }
                _selectedRentRate = rentRate;
              });
            }),
        const SizedBox(
          height: 25,
        ),
      ],
    );
  }
}
