import 'package:albazar_app/Features/ads/presentation/widgets/check_boxes_section.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/chip_section.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/numbers_section.dart';
import 'package:albazar_app/core/helper/theme_provider.dart';
import 'package:albazar_app/core/utils/constants.dart';
import 'package:albazar_app/core/utils/icons.dart';
import 'package:albazar_app/core/widgets/custom_drob_down.dart';
import 'package:albazar_app/core/widgets/fields/custom_labeled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:provider/provider.dart';

class CarsForSaleFiltersForm extends StatefulWidget {
  final Map<String, dynamic>? filters;
  const CarsForSaleFiltersForm({super.key, this.filters});

  @override
  State<CarsForSaleFiltersForm> createState() => CarsForSaleFiltersFormState();
}

class CarsForSaleFiltersFormState extends State<CarsForSaleFiltersForm> {
  // ignore: unused_field
  String _selectedBrand = '',
      _selectedFuelType = '',
      _selectedContactMethod = '',
      _selectedTransmission = '';
  int? _selectedseats = 0;
  final TextEditingController _priceFromController = TextEditingController(),
      _priceToController = TextEditingController(),
      _providedFromController = TextEditingController(),
      _providedToController = TextEditingController(),
      _kilometerFromController = TextEditingController(),
      _kilometerToController = TextEditingController(),
      _cityController = TextEditingController(),
      _currencyController = TextEditingController(),
      _descriptionController = TextEditingController(),
      _innerPartController = TextEditingController(),
      _doorsController = TextEditingController(),
      _colorController = TextEditingController(),
      _modelController = TextEditingController(),
      _versionController = TextEditingController(),
      _saleorRentController = TextEditingController(),
      _specificationsController = TextEditingController(),
      _carCategoryController = TextEditingController(),
      _importedFromController = TextEditingController(),
      _horsePowerController = TextEditingController(),
      _engineCapacityController = TextEditingController(),
      _numberOfDoorsController = TextEditingController();

  final List<String> _selectedAddOns = [];
  double _lowerValue = 1920;
  double _upperValue = 2025; // تحديث لتشمل كل السنوات
  double _lowerPriceValue = 0;
  double _upperPriceValue = 19999999; // أكبر قيمة ممكنة للسعر
  double _lowerKmValue = 0;
  double _upperKmValue = 500000; // 500 ألف كم - واقعي للسيارات المستعملة
  bool isChecked = false;
  String? _selectedCity;
  final List<String> addOns = [
    "وسائد هوائية",
    "راديو",
    "نوافذ كهربائية",
    "مرايا كهربائية",
    "نظام بلوتوث",
    "شاحن يو اس بى",
  ];
  final List<String> fuelTypes = [
    "البنزين",
    "كهرباء",
    "غاز طبيعى",
    "ديزل",
  ];
  final List<String> saleOrRentChoices = [
    "بيع",
    "إيجار",
  ];

  final List<String> carLogo = [
    AppIcons.ads,
    AppIcons.age,
    AppIcons.back,
    AppIcons.bathroom,
    AppIcons.chat,
  ];

  final List<String> newOrUsedChoices = [
    "جديد",
    "مستعمل",
  ];
  final List<String> isOwner = [
    "المالك",
    "وكيل",
  ];
  final List<String> transmissions = [
    "اتوماتيك",
    "يدوى/عادى",
  ];
  final List<String> contactMethods = [
    "كاش",
    "تقسيط",
    "كاش أو تقسيط",
  ];
  final List<Map<String, String>> carTypes = [
    {"label": "كوبيه", "image": "assets/images/car1.png"},
    {"label": "سيدان", "image": "assets/images/car2.png"},
    {"label": "كروس اوفر", "image": "assets/images/car3.png"},
    {"label": "سيارة مكشوفة", "image": "assets/images/car4.png"},
    {"label": "سيارة رياضية", "image": "assets/images/car5.png"},
    {"label": "جيب", "image": "assets/images/car6.png"},
    {"label": "هاتشباك", "image": "assets/images/car7.png"},
    {"label": "بيك أب", "image": "assets/images/car8.png"},
    {"label": "شاحنة صغيرة/فان", "image": "assets/images/car9.png"},
  ];
  String _dollarOrLeraa = 'ليره',
      _selectedSaleOrRentvalue = '',
      _selectedCarType = '',
      _publishedVia = '';
  String? selectedCarTypeeee;

  @override
  void initState() {
    _selectedBrand = widget.filters?["brand"] ?? '';
    _publishedVia = widget.filters?["publishedVia"] ?? '';
    _selectedFuelType = widget.filters?["fuel type"] ?? '';
    _selectedTransmission = widget.filters?["transmission type"] ?? '';
    _selectedCarType = widget.filters?["type"]?.toString() ?? '';
    _selectedseats = widget.filters?["number of sets"] ?? 0;
    _priceFromController.text = widget.filters?["price[gte]"]?.toString() ?? '';
    _priceToController.text = widget.filters?["price[lte]"]?.toString() ?? '';
    _providedFromController.text =
        widget.filters?["down payment[gte]"]?.toString() ?? '';
    _providedToController.text =
        widget.filters?["down payment[lte]"]?.toString() ?? '';
    _kilometerFromController.text =
        widget.filters?["kilometers[gte]"]?.toString() ?? '';
    _kilometerToController.text =
        widget.filters?["kilometers[lte]"]?.toString() ?? '';
    _descriptionController.text =
        widget.filters?["description"]?.toString() ?? '';
    _innerPartController.text = widget.filters?["inner part"]?.toString() ?? '';
    _doorsController.text =
        widget.filters?["number of doors"]?.toString() ?? '';
    _colorController.text = widget.filters?["color"]?.toString() ?? '';
    _modelController.text = widget.filters?["year"]?.toString() ?? '';
    _versionController.text = widget.filters?["virsion"]?.toString() ?? '';
    _saleorRentController.text =
        widget.filters?["listing status"]?.toString() ?? '';
    _cityController.text = widget.filters?["city"]?.toString() ?? '';
    _currencyController.text = widget.filters?["currency"]?.toString() ?? '';

    if (widget.filters?["additional features"] != null) {
      _selectedAddOns.add(widget.filters?["additional features"]);
    }

    // تحديد قيم السعر من الفلتر مع التأكد من الحدود
    if (widget.filters?["price[gte]"] != null) {
      _lowerPriceValue =
          (widget.filters!["price[gte]"] as num).toDouble().clamp(0, 20000000);
    }
    if (widget.filters?["price[lte]"] != null) {
      _upperPriceValue =
          (widget.filters!["price[lte]"] as num).toDouble().clamp(0, 20000000);
    }

    // تحديد قيم الكيلومترات من الفلتر مع التأكد من الحدود
    if (widget.filters?["kilometers[gte]"] != null) {
      _lowerKmValue = (widget.filters!["kilometers[gte]"] as num)
          .toDouble()
          .clamp(0, 500000);
    }
    if (widget.filters?["kilometers[lte]"] != null) {
      _upperKmValue = (widget.filters!["kilometers[lte]"] as num)
          .toDouble()
          .clamp(0, 500000);
    }

    // تحديد قيم سنة التصنيع من الفلتر مع التأكد من الحدود
    if (widget.filters?["year[gte]"] != null) {
      _lowerValue =
          (widget.filters!["year[gte]"] as num).toDouble().clamp(1920, 2025);
    }
    if (widget.filters?["year[lte]"] != null) {
      _upperValue =
          (widget.filters!["year[lte]"] as num).toDouble().clamp(1920, 2025);
    }

    // تحديد نوع السيارة من الفلتر
    selectedCarTypeeee = widget.filters?["Car Type"]?.toString();

    // تحديد البيانات الإضافية
    _specificationsController.text =
        widget.filters?["description"]?.toString() ?? '';
    _carCategoryController.text = widget.filters?["version"]?.toString() ?? '';
    _importedFromController.text =
        widget.filters?["Imported"]?.toString() ?? '';
    _horsePowerController.text =
        widget.filters?["Horsepower"]?.toString() ?? '';
    _engineCapacityController.text =
        widget.filters?["Engine Capacity"]?.toString() ?? '';
    _numberOfDoorsController.text =
        widget.filters?["number of doors"]?.toString() ?? '';
    _selectedSaleOrRentvalue =
        widget.filters?["listing status"]?.toString() ?? '';

    super.initState();
  }

  Map<String, dynamic> search() {
    final searchParams = <String, dynamic>{
      // المعاملات الأساسية ستُرسل من queryOptions، لا نحتاجها هنا
      // "category": "6816814c919277fc38d33027",
      // "sort": "-createdAt",

      // الفلاتر المختارة فقط
      if (_selectedCity != null && _selectedCity!.trim().isNotEmpty)
        "city": _selectedCity!.trim(),
      if (_selectedBrand.isNotEmpty)
        "brand": Uri.encodeComponent(_selectedBrand),
      if (_specificationsController.text.trim().isNotEmpty)
        "description": _specificationsController.text.trim(),
      if (_carCategoryController.text.trim().isNotEmpty)
        "version": _carCategoryController.text.trim(),
      // مؤقتاً: تعطيل فلتر السنة للاختبار
      // if (_lowerValue > 1920) "year[gte]": _lowerValue.toInt(),
      // if (_upperValue < 2025) "year[lte]": _upperValue.toInt(),
      if (_importedFromController.text.trim().isNotEmpty)
        "Imported": _importedFromController.text.trim(),
      if (_horsePowerController.text.trim().isNotEmpty)
        "Horsepower": _horsePowerController.text.trim(),
      if (_engineCapacityController.text.trim().isNotEmpty)
        "Engine Capacity": _engineCapacityController.text.trim(),
      if (_colorController.text.trim().isNotEmpty)
        "color": _colorController.text.trim(),
      if (_numberOfDoorsController.text.trim().isNotEmpty)
        "number of doors": _numberOfDoorsController.text.trim(),
      if (_innerPartController.text.trim().isNotEmpty)
        "inner part": _innerPartController.text.trim(),
      if (_selectedseats != 0) "number of sets": _selectedseats,
      if (_selectedCarType.isNotEmpty) "type": _selectedCarType,
      if (_selectedSaleOrRentvalue.isNotEmpty)
        "listing status": _selectedSaleOrRentvalue,
      if (_currencyController.text.trim().isNotEmpty)
        "currency": _currencyController.text.trim(),
      // مؤقتاً: تعطيل فلتر السعر للاختبار
      // if (_lowerPriceValue > 0) "price[gte]": _lowerPriceValue.toInt(),
      // if (_upperPriceValue < 20000000) "price[lte]": _upperPriceValue.toInt(),
      if (_lowerKmValue > 0) "kilometers[gte]": _lowerKmValue.toInt(),
      if (_upperKmValue < 500000) "kilometers[lte]": _upperKmValue.toInt(),
      if (selectedCarTypeeee != null && selectedCarTypeeee!.isNotEmpty)
        "Car Type": selectedCarTypeeee,
      if (_selectedAddOns.isNotEmpty)
        "additional features": _selectedAddOns.join(', '),
      if (_selectedFuelType.isNotEmpty) "fuel type": _selectedFuelType,
      if (_selectedTransmission.isNotEmpty)
        "transmission type": _selectedTransmission,
    };

    // طباعة البيانات للتحقق
    print("🔍 Car Filter Search Parameters:");
    print(searchParams);

    // طباعة المدينة والماركة بشكل خاص
    if (_selectedCity != null && _selectedCity!.trim().isNotEmpty) {
      print("🏙️ Selected City: '$_selectedCity'");
    }
    if (_selectedBrand.isNotEmpty) {
      print("🚗 Selected Brand: '$_selectedBrand'");
    }

    // طباعة عدد المعاملات المرسلة
    print("📊 Total parameters: ${searchParams.length}");

    return searchParams;
  }

  @override
  void dispose() {
    _priceFromController.dispose();
    _priceToController.dispose();
    _kilometerFromController.dispose();
    _kilometerToController.dispose();
    _descriptionController.dispose();
    _innerPartController.dispose();
    _doorsController.dispose();
    _colorController.dispose();
    _modelController.dispose();
    _versionController.dispose();
    _cityController.dispose();
    _currencyController.dispose();
    _saleorRentController.dispose();
    _specificationsController.dispose();
    _carCategoryController.dispose();
    _importedFromController.dispose();
    _horsePowerController.dispose();
    _engineCapacityController.dispose();
    _numberOfDoorsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      cacheExtent: 10000,
      children: [
        Text(
          'الموقع',
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
            selectedValue: _selectedCity == null || _selectedCity!.isEmpty
                ? null
                : _selectedCity,
            // label: 'المحافظة',
            // carLogo: ,
            hint: 'اختر المحافظة',
            options: AppConstants.cityLists,
            onChanged: (city) {
              if (mounted) {
                setState(() {
                  _selectedCity = city!;
                  _cityController.text = city;
                });
              }
            }),
        const SizedBox(
          height: 20,
        ),
        // CustomLabeledDropDownField(
        //   label: 'الماركة',
        //   hint: "اختار ماركة السيارة ...",
        //   items: AppConstants.carBrands,
        //   value: _selectedBrand.isEmpty ? null : _selectedBrand,
        //   onChanged: (brand) {
        //     setState(() {
        //       _selectedBrand = brand!;
        //     });
        //   },
        // ),
        Text(
          'الماركة',
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
            selectedValue: _selectedBrand.isEmpty ? null : _selectedBrand,

            // label: 'المحافظة',
            hint: "اختار ماركة السيارة ...",
            // options: AppConstants.carBrands,
            carOptions: AppConstants.cars,
            onChanged: (brand) {
              if (mounted) {
                setState(() {
                  _selectedBrand = brand!;
                  // _cityController.text = brand;
                });
              }
            }),
        const SizedBox(
          height: 25,
        ),
        CustomLabeledTextField(
          controller: _modelController,
          keyboardType: TextInputType.number,
          validator: (adTitle) {
            if (adTitle!.isEmpty) {
              return 'من فضلك ادخل موديل السيارة';
            }
            return null;
          },
          label: 'الموديل',
          hint: "الموديل",
        ),
        const SizedBox(
          height: 25,
        ),
        CustomLabeledTextField(
          controller: _specificationsController,
          keyboardType: TextInputType.text,
          validator: (adTitle) {
            if (adTitle!.isEmpty) {
              return 'من فضلك ادخل المواصفات';
            }
            return null;
          },
          label: 'المواصفات',
          hint: "المواصفات",
        ),
        const SizedBox(
          height: 25,
        ),
        CustomLabeledTextField(
          controller: _carCategoryController,
          keyboardType: TextInputType.text,
          validator: (adTitle) {
            if (adTitle!.isEmpty) {
              return 'من فضلك ادخل فئة السيارة';
            }
            return null;
          },
          label: 'فئة السيارة',
          hint: "فئة السيارة",
        ),

        const SizedBox(
          height: 25,
        ),
        SizedBox(
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'سنة التصنيع',
                    style: TextStyle(
                      color: Theme.of(context).focusColor,
                      fontSize: 16,
                      fontFamily: 'Noor',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildYearBox(_upperValue.toInt().toString()), // "إلى"
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("إلى", style: TextStyle(color: Colors.grey)),
                  ),
                  _buildYearBox(_lowerValue.toInt().toString()), // "من"
                ],
              ),
              // const SizedBox(height: 16),
              FlutterSlider(
                values: [_lowerValue, _upperValue],
                rangeSlider: true,
                max: 2025,
                min: 1920,
                step: const FlutterSliderStep(step: 1),
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
                      _lowerValue = lowerValue;
                      _upperValue = upperValue;
                    });
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        CustomLabeledTextField(
          controller: _importedFromController,
          keyboardType: TextInputType.text,
          validator: (adTitle) {
            if (adTitle!.isEmpty) {
              return 'وارد السيارة';
            }
            return null;
          },
          label: 'وارد',
          hint: "وارد السيارة",
        ),
        const SizedBox(
          height: 25,
        ),
        CustomLabeledTextField(
          controller: _horsePowerController,
          keyboardType: TextInputType.number,
          validator: (adTitle) {
            if (adTitle!.isEmpty) {
              return 'من فضلك ادخل قوة الحصان';
            }
            return null;
          },
          label: 'قوة الحصان',
          hint: "ادخل قوة الحصان",
        ),
        const SizedBox(
          height: 25,
        ),
        CustomLabeledTextField(
          controller: _engineCapacityController,
          keyboardType: TextInputType.number,
          validator: (adTitle) {
            if (adTitle!.isEmpty) {
              return 'من فضلك ادخل سعة المحرك';
            }
            return null;
          },
          label: 'سعة المحرك',
          hint: "ادخل سعة المحرك",
        ),
        const SizedBox(
          height: 25,
        ),
        CustomLabeledTextField(
          controller: _colorController,
          keyboardType: TextInputType.text,
          validator: (adTitle) {
            if (adTitle!.isEmpty) {
              return 'من فضلك ادخل لون السيارة';
            }
            return null;
          },
          label: 'لون السيارة',
          hint: "لون السيارة",
        ),
        const SizedBox(
          height: 25,
        ),
        CustomLabeledTextField(
          controller: _numberOfDoorsController,
          keyboardType: TextInputType.number,
          validator: (adTitle) {
            if (adTitle!.isEmpty) {
              return 'من فضلك ادخل عدد الابواب';
            }
            return null;
          },
          label: 'عدد الابواب',
          hint: "عدد الابواب",
        ),
        const SizedBox(
          height: 25,
        ),
        CustomLabeledTextField(
          controller: _innerPartController,
          validator: (adTitle) {
            if (adTitle!.isEmpty) {
              return 'من فضلك ادخل الجزء الداخلى';
            }
            return null;
          },
          label: 'لون الجزء الداخلى',
          hint: "لون الجزء الداخلى",
        ),
        const SizedBox(
          height: 25,
        ),
        NumbersSection(
          title: 'عدد المقاعد',
          maxNumbers: 7,
          selectedNumber: _selectedseats!,
          onSelect: (room) {
            setState(() {
              _selectedseats = room;
            });
          },
        ),
        const SizedBox(
          height: 25,
        ),
        ChipSection(
          title: 'جديد/مستعمل',
          items: newOrUsedChoices,
          selectedItems: [_selectedCarType],
          onSelect: (choice) {
            setState(() {
              _selectedCarType = choice;
            });
          },
        ),
        const SizedBox(
          height: 25,
        ),

        ChipSection(
          title: 'بيع/ايجار',
          items: saleOrRentChoices,
          selectedItems: [_selectedSaleOrRentvalue],
          onSelect: (choice) {
            setState(() {
              _selectedSaleOrRentvalue = choice;
              _saleorRentController.text = choice;
            });
          },
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
              if (mounted) {
                setState(() {
                  _dollarOrLeraa = curruncy!;
                  _currencyController.text = curruncy;
                });
              }
            }),
        const SizedBox(
          height: 25,
        ),
        SizedBox(
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'السعر',
                    style: TextStyle(
                      color: Theme.of(context).focusColor,
                      fontSize: 16,
                      fontFamily: 'Noor',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildPriceBox(_lowerPriceValue.toInt().toString()), // "من"
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("إلى", style: TextStyle(color: Colors.grey)),
                  ),
                  _buildPriceBox(_upperPriceValue.toInt().toString()), // "إلى"
                ],
              ),
              FlutterSlider(
                values: [_lowerPriceValue, _upperPriceValue],
                rangeSlider: true,
                max: 20000000,
                min: 0,
                step: const FlutterSliderStep(step: 10000),
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
                    });
                  }
                },
              ),
            ],
          ),
        ),

        const SizedBox(
          height: 25,
        ),
        SizedBox(
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'كيلومترات',
                    style: TextStyle(
                      color: Theme.of(context).focusColor,
                      fontSize: 16,
                      fontFamily: 'Noor',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildKmBox(_lowerKmValue.toInt().toString()), // "من"
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("إلى", style: TextStyle(color: Colors.grey)),
                  ),
                  _buildKmBox(_upperKmValue.toInt().toString()), // "إلى"
                ],
              ),
              FlutterSlider(
                values: [_lowerKmValue, _upperKmValue],
                rangeSlider: true,
                max: 500000, // 500 ألف كم
                min: 0,
                step: const FlutterSliderStep(step: 5000), // خطوات 5000 كم
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
                      _lowerKmValue = lowerValue;
                      _upperKmValue = upperValue;
                    });
                  }
                },
              ),
            ],
          ),
        ),

        const SizedBox(
          height: 25,
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'نوع السيارة',
              style: TextStyle(
                color: Theme.of(context).focusColor,
                fontSize: 16,
                fontFamily: 'Noor',
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 10,
              childAspectRatio: 0.9,
              children: [
                ...carTypes.map(
                  (car) => _buildCarCard(
                    car['label']!,
                    car['image']!,
                    onSelect: (value) {
                      if (mounted) {
                        setState(() {
                          selectedCarTypeeee = value;
                        });
                      }
                    },
                  ),
                ),
                _buildOtherCard(context, (value) {
                  if (mounted) {
                    setState(() {
                      selectedCarTypeeee = value;
                    });
                  }
                }),
              ],
            ),
          ],
        ),

        const SizedBox(
          height: 25,
        ),
        CheckBoxesSection(
            title: 'إضافات',
            isList: true,
            items: addOns,
            selectedItems: _selectedAddOns.isEmpty ? [] : _selectedAddOns,
            onChanged: (addOn) {
              print("📦 AddOn clicked: $addOn");
              print("📦 Current selected: $_selectedAddOns");
              if (mounted) {
                setState(() {
                  if (_selectedAddOns.contains(addOn)) {
                    _selectedAddOns.remove(addOn);
                    print("📦 Removed: $addOn");
                  } else {
                    _selectedAddOns.add(addOn);
                    print("📦 Added: $addOn");
                  }
                  print("📦 New selected: $_selectedAddOns");
                });
              }
            }),
        const SizedBox(
          height: 25,
        ),
        CheckBoxesSection(
            title: 'نوع الوقود',
            isList: true,
            items: fuelTypes,
            selectedItems: _selectedFuelType.isEmpty ? [] : [_selectedFuelType],
            onChanged: (fuelType) {
              print("⛽ Fuel clicked: $fuelType");
              print("⛽ Current selected: $_selectedFuelType");
              if (mounted) {
                setState(() {
                  if (_selectedFuelType == fuelType) {
                    _selectedFuelType = '';
                    print("⛽ Cleared selection");
                  } else {
                    _selectedFuelType = fuelType;
                    print("⛽ Selected: $fuelType");
                  }
                });
              }
            }),
        const SizedBox(
          height: 25,
        ),
        CheckBoxesSection(
            title: 'ناقل الحركة',
            isList: true,
            items: transmissions,
            selectedItems:
                _selectedTransmission.isEmpty ? [] : [_selectedTransmission],
            onChanged: (transmission) {
              print("🚗 Transmission clicked: $transmission");
              print("🚗 Current selected: $_selectedTransmission");
              if (mounted) {
                setState(() {
                  if (_selectedTransmission == transmission) {
                    _selectedTransmission = '';
                    print("🚗 Cleared selection");
                  } else {
                    _selectedTransmission = transmission;
                    print("🚗 Selected: $transmission");
                  }
                });
              }
            }),
      ],
    );
  }

  Widget _buildYearBox(String year) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isLight = themeProvider.themeMode == ThemeMode.light;
    return Container(
      width: 80,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
        color: isLight ? Colors.grey.shade50 : Colors.black,
      ),
      child: Text(
        year,
        style: const TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  Widget _buildPriceBox(String price) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isLight = themeProvider.themeMode == ThemeMode.light;
    return Container(
      width: 80,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
        color: isLight ? Colors.grey.shade50 : Colors.black,
      ),
      child: Text(
        price,
        style: const TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  Widget _buildKmBox(String km) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isLight = themeProvider.themeMode == ThemeMode.light;
    return Container(
      width: 80,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
        color: isLight ? Colors.grey.shade50 : Colors.black,
      ),
      child: Text(
        km,
        style: const TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  Widget _buildCarCard(String label, String imagePath,
      {required void Function(String) onSelect}) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isLight = themeProvider.themeMode == ThemeMode.light;
    return GestureDetector(
      onTap: () => onSelect(label),
      child: Card(
        surfaceTintColor: Colors.transparent,
        color: isLight ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: selectedCarTypeeee == label ? Colors.yellow : Colors.black,
            width: selectedCarTypeeee == label ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                flex: 2,
                child: Image.asset(
                  imagePath,
                  height: 40,
                  width: 40,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                flex: 1,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtherCard(BuildContext context, void Function(String) onSelect) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isLight = themeProvider.themeMode == ThemeMode.light;
    final List<String> moreCarTypes = [
      "ليموزين",
      "سيارة كلاسيكية",
      "سيارة كهربائية",
      "ميني فان",
      "شاحنة نقل",
      "دراجة نارية بثلاث عجلات",
      "عربة سكن متنقلة",
      "غير ذالك"
    ];

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          isScrollControlled: true,
          builder: (_) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "أنواع سيارات إضافية",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: moreCarTypes.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(moreCarTypes[index]),
                        leading: const Icon(Icons.directions_car),
                        onTap: () {
                          Navigator.pop(context);
                          onSelect(moreCarTypes[index]);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: Card(
        surfaceTintColor: Colors.transparent,
        color: isLight ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.black),
        ),
        child: const Padding(
          padding: EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                flex: 2,
                child: Icon(Icons.add_circle_outline,
                    size: 30, color: Colors.grey),
              ),
              SizedBox(height: 4),
              Flexible(
                flex: 1,
                child: Text(
                  "أخرى",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
