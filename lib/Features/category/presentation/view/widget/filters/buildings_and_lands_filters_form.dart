import 'package:albazar_app/Features/ads/presentation/widgets/check_boxes_section.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/chip_section.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/custom_check_box.dart';
import 'package:albazar_app/core/helper/theme_provider.dart';
import 'package:albazar_app/core/utils/constants.dart';
import 'package:albazar_app/core/widgets/custom_drob_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:provider/provider.dart';

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
  String _dollarOrLeraa = 'ليرة';
  String _selectedLandType = '',
      _selectedSaleOrRent = '',
      _selectedContactMethod = '',
      _publishedVia = '',
      _selectedLocation = '';
  bool isChecked = false;

  // Area slider variables
  double _lowerAreaValue = 0;
  double _upperAreaValue = 2000; // 2000 sqm max area for lands

  // Price slider variables
  double _lowerPriceValue = 0;
  double _upperPriceValue = 50000000; // 50 million max price for lands

  final List<String> landTypes = [
    "زراعي",
    "تجاري",
    "صناعي",
    "سكني",
  ];
  final List<String> furnitureChoices = [
    "نعم",
    "لا",
  ];
  final List<String> rentRates = [
    "يومياً",
    "أسبوعياً",
    "شهرياً",
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

    // Initialize area slider values from filters
    if (widget.filters?["area[gte]"] != null) {
      _lowerAreaValue =
          (widget.filters!["area[gte]"] as num).toDouble().clamp(0, 2000);
    }
    if (widget.filters?["area[lte]"] != null) {
      _upperAreaValue =
          (widget.filters!["area[lte]"] as num).toDouble().clamp(0, 2000);
    }

    // Initialize price slider values from filters
    if (widget.filters?["price[gte]"] != null) {
      _lowerPriceValue =
          (widget.filters!["price[gte]"] as num).toDouble().clamp(0, 50000000);
    }
    if (widget.filters?["price[lte]"] != null) {
      _upperPriceValue =
          (widget.filters!["price[lte]"] as num).toDouble().clamp(0, 50000000);
    }

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
              max: 2000, // Max 2000 sqm for lands
              min: 0,
              step: const FlutterSliderStep(step: 10), // 10 sqm steps
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
            options: const ['دولار', 'ليرة'],
            onChanged: (curruncy) {
              setState(() {
                _dollarOrLeraa = curruncy!;
                _currencyController.text = curruncy;

                // Reset price values when currency changes to avoid max value errors
                if (curruncy == 'دولار') {
                  // Switch to USD - check if current values exceed USD limits
                  if (_upperPriceValue > 1000000) {
                    _upperPriceValue = 1000000;
                    _priceToController.text = '1000000';
                  }
                  if (_lowerPriceValue > 1000000) {
                    _lowerPriceValue = 0;
                    _priceFromController.text = '0';
                  }
                } else {
                  // Switch to SYP - set reasonable default values
                  if (_upperPriceValue > 50000000) {
                    _upperPriceValue = 50000000;
                    _priceToController.text = '50000000';
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
                  ? 1000000
                  : 50000000, // Adjust max based on currency
              min: 0,
              step: FlutterSliderStep(
                  step: _dollarOrLeraa == 'دولار'
                      ? 1000
                      : 100000), // Adjust step based on currency
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
