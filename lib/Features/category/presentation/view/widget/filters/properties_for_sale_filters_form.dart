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
  String _dollarOrLeraa = 'ليرة';
  String _selectedBuilding = '',
      _selectedRentRate = '',
      _selectedChoice = '',
      _selectedLocation = '',
      _publishedVia = '',
      _selectedBuildingStatus = '',
      _selectedContactMethod = '',
      _selectedDeliveryTerm = '';
  final List<String> _selectedLuxuries = [];
  bool isChecked = false;

  int _selectedRoom = 0, _selectedBathroom = 0;

  // Price slider variables
  double _lowerPriceValue = 0;
  double _upperPriceValue = 10000000; // 20 million max price

  // Area slider variables
  double _lowerAreaValue = 0;
  double _upperAreaValue = 1000; // 1000 sqm max area

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

    // Initialize price slider values from filters
    if (widget.filters?["price[gte]"] != null) {
      _lowerPriceValue =
          (widget.filters!["price[gte]"] as num).toDouble().clamp(0, 20000000);
    }
    if (widget.filters?["price[lte]"] != null) {
      _upperPriceValue =
          (widget.filters!["price[lte]"] as num).toDouble().clamp(0, 20000000);
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
  }

  Map<String, dynamic> search() => {
        // المحافظة : city
        if (_cityController.text.trim().isNotEmpty)
          "city": _cityController.text.trim(),

        // داخل / خارج التنظيم : regulationStatus
        if (_selectedLocation.isNotEmpty) "regulationStatus": _selectedLocation,

        // تم النشر من قبل : publishedVia
        if (_publishedVia.isNotEmpty) "publishedVia": _publishedVia,

        // نوع العقار : property type
        if (_selectedBuilding.isNotEmpty) "property type": _selectedBuilding,

        // المساحة : area[gte] , area[lte]
        if (_areaFromController.text.trim().isNotEmpty)
          "area[gte]": num.parse(_areaFromController.text.trim()),
        if (_areaToController.text.trim().isNotEmpty)
          "area[lte]": num.parse(_areaToController.text.trim()),

        // الطابق : floor
        if (_floorController.text.trim().isNotEmpty)
          "floor": _floorController.text.trim(),

        // العملة : currency
        if (_currencyController.text.trim().isNotEmpty)
          "currency": _currencyController.text.trim(),

        // السعر : price[gte] , price[lte]
        if (_priceFromController.text.trim().isNotEmpty)
          "price[gte]": num.parse(_priceFromController.text.trim()),
        if (_priceToController.text.trim().isNotEmpty)
          "price[lte]": num.parse(_priceToController.text.trim()),

        // قابل للتفاوض : negotiable
        if (isChecked) "negotiable": isChecked,

        // الكماليات : amenities
        if (_selectedLuxuries.isNotEmpty) "amenities": _selectedLuxuries.first,

        // عدد الغرف : number of rooms
        if (_selectedRoom > 0) "number of rooms": _selectedRoom,

        // عدد الحمامات : number of bathrooms
        if (_selectedBathroom > 0) "number of bathrooms": _selectedBathroom,

        // الفرش : furnishing
        if (_selectedChoice.isNotEmpty)
          "furnishing": _selectedChoice == furnitureChoices.first,

        // طريقة الدفع : payment method
        if (_selectedContactMethod.isNotEmpty)
          "payment method": _selectedContactMethod,

        // شروط التسليم : delivery conditions
        if (_selectedDeliveryTerm.isNotEmpty)
          "delivery conditions": _selectedDeliveryTerm,

        // عمر المبني : year
        if (_buildingAgeontroller.text.trim().isNotEmpty)
          "year": _buildingAgeontroller.text.trim(),

        // حالة العقار : property condition
        if (_selectedBuildingStatus.isNotEmpty)
          "property condition": _selectedBuildingStatus,
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

  // Helper method to build price display boxes
  Widget _buildPriceBox(String value) {
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
        '$formattedValue م٢',
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
              step: const FlutterSliderStep(
                  step: 5), // 5 sqm steps (reduced from 10)
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
          height: 10,
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
            options: const ['دولار', 'ليرة'],
            onChanged: (curruncy) {
              setState(() {
                _dollarOrLeraa = curruncy!;
                _currencyController.text = curruncy;

                // Reset price values when currency changes to avoid max value errors
                if (curruncy == 'دولار') {
                  // Switch to USD - check if current values exceed USD limits
                  if (_upperPriceValue > 500000) {
                    _upperPriceValue = 500000;
                    _priceToController.text = '500000';
                  }
                  if (_lowerPriceValue > 500000) {
                    _lowerPriceValue = 0;
                    _priceFromController.text = '0';
                  }
                } else {
                  // Switch to SYP - set reasonable default values
                  if (_upperPriceValue > 10000000) {
                    _upperPriceValue = 10000000;
                    _priceToController.text = '10000000';
                  }
                  // Keep the lower value as is since SYP max is higher
                }
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
        const SizedBox(
          height: 25,
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPriceBox(_upperPriceValue.toInt().toString()), // "إلى"
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("إلى", style: TextStyle(color: Colors.grey)),
                ),
                _buildPriceBox(_lowerPriceValue.toInt().toString()), // "من"
              ],
            ),
            const SizedBox(height: 16),
            FlutterSlider(
              values: [_lowerPriceValue, _upperPriceValue],
              rangeSlider: true,
              max: _dollarOrLeraa == 'دولار'
                  ? 500000
                  : 20000000, // Adjust max based on currency
              min: 0,
              step: FlutterSliderStep(
                  step: _dollarOrLeraa == 'دولار'
                      ? 100 // Reduced from 1000 to 100 USD
                      : 10000), // Reduced from 100000 to 10000 SYP
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
                    _lowerPriceValue = lowerValue;
                    _upperPriceValue = upperValue;
                    // Update text controllers for compatibility with search method
                    _priceFromController.text = lowerValue.toInt().toString();
                    _priceToController.text = upperValue.toInt().toString();
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
