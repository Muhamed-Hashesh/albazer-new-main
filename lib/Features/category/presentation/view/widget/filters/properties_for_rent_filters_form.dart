import 'package:albazar_app/Features/ads/presentation/widgets/check_boxes_section.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/chip_section.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/custom_check_box.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/numbers_section.dart';
import 'package:albazar_app/core/helper/theme_provider.dart';
import 'package:albazar_app/core/utils/constants.dart';
import 'package:albazar_app/core/widgets/custom_drob_down.dart';
import 'package:albazar_app/core/widgets/fields/custom_labeled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:provider/provider.dart';

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
  String _dollarOrLeraa = 'ليرة';

  String _selectedBuilding = '',
      _selectedRentRate = '',
      _selectedLocation = '',
      _publishedVia = '',
      _selectedType = '',
      _selectedChoice = '';
  final List<String> _selectedLuxuries = [];
  bool isChecked = false;

  int _selectedRoom = 0, _selectedBathroom = 0;

  // Area slider variables
  double _lowerAreaValue = 0;
  double _upperAreaValue = 1000; // 1000 sqm max area

  // Rental fees slider variables
  double _lowerRentalFeesValue = 0;
  double _upperRentalFeesValue = 5000000; // 5 million max rental fees

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

    // Initialize area slider values from filters
    if (widget.filters?["area[gte]"] != null) {
      _lowerAreaValue =
          (widget.filters!["area[gte]"] as num).toDouble().clamp(0, 1000);
    }
    if (widget.filters?["area[lte]"] != null) {
      _upperAreaValue =
          (widget.filters!["area[lte]"] as num).toDouble().clamp(0, 1000);
    }

    // Initialize rental fees slider values from filters
    if (widget.filters?["rental fees[gte]"] != null) {
      _lowerRentalFeesValue = (widget.filters!["rental fees[gte]"] as num)
          .toDouble()
          .clamp(0, 5000000);
    }
    if (widget.filters?["rental fees[lte]"] != null) {
      _upperRentalFeesValue = (widget.filters!["rental fees[lte]"] as num)
          .toDouble()
          .clamp(0, 5000000);
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

  // Helper method to build area display boxes
  Widget _buildAreaBox(String value) {
    final formattedValue = double.parse(value).toStringAsFixed(0);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isLight = themeProvider.themeMode == ThemeMode.light;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: isLight ? Colors.grey.shade50 : Colors.black,
      ),
      child: Text(
        '$formattedValue m2',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).focusColor,
        ),
      ),
    );
  }

  // Helper method to build rental fees display boxes
  Widget _buildRentalFeesBox(String value) {
    final currency = _dollarOrLeraa == 'دولار' ? 'USD' : 'SYP';
    final formattedValue = double.parse(value).toStringAsFixed(0);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isLight = themeProvider.themeMode == ThemeMode.light;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: isLight ? Colors.grey.shade50 : Colors.black,
      ),
      child: Text(
        '$formattedValue $currency',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).focusColor,
        ),
      ),
    );
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
          'المساحة (m2)*',
          style: TextStyle(
            color: Theme.of(context).focusColor,
            fontSize: 16,
            fontFamily: 'Noor',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAreaBox(_upperAreaValue.toInt().toString()), // "إلى"
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("إلى", style: TextStyle(color: Colors.grey)),
                ),
                _buildAreaBox(_lowerAreaValue.toInt().toString()), // "من"
              ],
            ),
            const SizedBox(height: 16),
            FlutterSlider(
              values: [_lowerAreaValue, _upperAreaValue],
              rangeSlider: true,
              max: 1000, // Max 1000 sqm
              min: 0,
              step: const FlutterSliderStep(step: 5), // 5 sqm steps
              handler: FlutterSliderHandler(
                decoration: const BoxDecoration(),
                child: const CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.yellow,
                ),
              ),
              rightHandler: FlutterSliderHandler(
                decoration: const BoxDecoration(),
                child: const CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.yellow,
                ),
              ),
              trackBar: const FlutterSliderTrackBar(
                activeTrackBar: BoxDecoration(color: Colors.yellow),
              ),
              onDragging: (handlerIndex, lowerValue, upperValue) {
                if (mounted) {
                  setState(() {
                    _lowerAreaValue = lowerValue;
                    _upperAreaValue = upperValue;
                    // Update text controllers for compatibility with search method
                    _areaFromController.text = lowerValue.toInt().toString();
                    _areaToController.text = upperValue.toInt().toString();
                  });
                }
              },
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
            options: const ['دولار', 'ليرة'],
            onChanged: (curruncy) {
              setState(() {
                _dollarOrLeraa = curruncy!;
                _currencyController.text = curruncy;

                // Reset rental fees values when currency changes to avoid max value errors
                if (curruncy == 'دولار') {
                  // Switch to USD - check if current values exceed USD limits
                  if (_upperRentalFeesValue > 10000) {
                    _upperRentalFeesValue = 10000;
                    _feesToController.text = '10000';
                  }
                  if (_lowerRentalFeesValue > 10000) {
                    _lowerRentalFeesValue = 0;
                    _feesFromController.text = '0';
                  }
                } else {
                  // Switch to SYP - set reasonable default values
                  if (_upperRentalFeesValue > 5000000) {
                    _upperRentalFeesValue = 5000000;
                    _feesToController.text = '5000000';
                  }
                  // Keep the lower value as is since SYP max is higher
                }
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
        const SizedBox(
          height: 25,
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildRentalFeesBox(
                    _upperRentalFeesValue.toInt().toString()), // "إلى"
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("إلى", style: TextStyle(color: Colors.grey)),
                ),
                _buildRentalFeesBox(
                    _lowerRentalFeesValue.toInt().toString()), // "من"
              ],
            ),
            const SizedBox(height: 16),
            FlutterSlider(
              values: [_lowerRentalFeesValue, _upperRentalFeesValue],
              rangeSlider: true,
              max: _dollarOrLeraa == 'دولار'
                  ? 10000
                  : 5000000, // Adjust max based on currency
              min: 0,
              step: FlutterSliderStep(
                  step: _dollarOrLeraa == 'دولار'
                      ? 50
                      : 10000), // Adjust step based on currency
              handler: FlutterSliderHandler(
                decoration: const BoxDecoration(),
                child: const CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.yellow,
                ),
              ),
              rightHandler: FlutterSliderHandler(
                decoration: const BoxDecoration(),
                child: const CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.yellow,
                ),
              ),
              trackBar: const FlutterSliderTrackBar(
                activeTrackBar: BoxDecoration(color: Colors.yellow),
              ),
              onDragging: (handlerIndex, lowerValue, upperValue) {
                if (mounted) {
                  setState(() {
                    _lowerRentalFeesValue = lowerValue;
                    _upperRentalFeesValue = upperValue;
                    // Update text controllers for compatibility with search method
                    _feesFromController.text = lowerValue.toInt().toString();
                    _feesToController.text = upperValue.toInt().toString();
                  });
                }
              },
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
