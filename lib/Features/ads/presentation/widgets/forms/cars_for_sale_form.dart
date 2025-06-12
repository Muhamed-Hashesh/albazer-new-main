import 'dart:developer';
import 'dart:io';

import 'package:albazar_app/Features/ads/data/models/ad.dart';
import 'package:albazar_app/Features/ads/presentation/cubit/new_ad_cubit.dart';
import 'package:albazar_app/Features/ads/presentation/view/google_map_screen.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/check_boxes_section.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/chip_section.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/custom_check_box.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/number_field.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/submit_ad_button.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/upload_photos_section.dart';
import 'package:albazar_app/Features/category/data/models/category.dart';
import 'package:albazar_app/core/di/locator.dart';
import 'package:albazar_app/core/helper/messages.dart';
import 'package:albazar_app/core/helper/user_helper.dart';
import 'package:albazar_app/core/utils/constants.dart';
import 'package:albazar_app/core/widgets/custom_drob_down.dart';
import 'package:albazar_app/core/widgets/fields/custom_labeled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../numbers_section.dart';

class CarsForSaleForm extends StatefulWidget {
  final Category category;
  const CarsForSaleForm({super.key, required this.category});

  @override
  State<CarsForSaleForm> createState() => _CarsForSaleFormState();
}

class _CarsForSaleFormState extends State<CarsForSaleForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, GlobalKey> _fieldKeys = {
    'brand': GlobalKey(),
    'version': GlobalKey(),
    'model': GlobalKey(),
    'color': GlobalKey(),
    'doors': GlobalKey(),
    'interior': GlobalKey(),
    'seats': GlobalKey(),
    'condition': GlobalKey(),
    'owner': GlobalKey(),
    'saleType': GlobalKey(),
    'adTitle': GlobalKey(),
    'description': GlobalKey(),
    'city': GlobalKey(),
    'location': GlobalKey(),
    'currency': GlobalKey(),
    'payment': GlobalKey(),
    'price': GlobalKey(),
    'addons': GlobalKey(),
    'fuel': GlobalKey(),
    'transmission': GlobalKey(),
    'mileage': GlobalKey(),
    'name': GlobalKey(),
    'phone': GlobalKey(),
    'contact': GlobalKey(),
    'years': GlobalKey(),
    'horsePower': GlobalKey(), ///////////////
    'engineCapacity': GlobalKey(), ///////////
    'bumber': GlobalKey(), //////drivetrain///////
    'imported': GlobalKey(), /////////////////////
  };

  final TextEditingController _adTitleController = TextEditingController(),
      _descriptionController = TextEditingController(),
      _locationController = TextEditingController(),
      _priceController = TextEditingController(),
      _nameController = TextEditingController(),
      _phoneController = TextEditingController(),
      _kilometerController = TextEditingController(),
      _colorController = TextEditingController(),
      _modelController = TextEditingController(),
      _versionController = TextEditingController(),
      _doorsController = TextEditingController(),
      _innerPartController = TextEditingController(),
      _sypController = TextEditingController(),
      _horsePowerController = TextEditingController(),
      _engineCapacityController = TextEditingController();
  final List<File> _images = [];
  String _selectedFuelType = '',
      _selectedTransmission = '',
      _selectedPaymentMethod = '',
      _owner = '',
      _dollarOrLera = 'ليره',
      _selectedSaleOrRent = '',
      // ignore: prefer_final_fields
      _selectedCarType = '';
  String? _selectedCity;
  String? _selectedBrand;
  String? _selectedBumper;
  String? _selectedImported;
  String? _selectedYears;
  String? selectedCarTypeeee;
  int? _selectedseats = 0;
  bool _negotiable = false;
  double? lat;
  double? long;
  final List<String> _selectedAddOns = [];
  final List<String> _selectedContactMethod = [];
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
  final List<String> contactMethods = [
    "موبايل",
    "شات",
  ];
  final List<String> years = [
    "",
    "1920",
    "1921",
    "1922",
    "1923",
    "1924",
    "1925",
    "1926",
    "1927",
    "1928",
    "1929",
    "1930",
    "1931",
    "1932",
    "1933",
    "1934",
    "1935",
    "1936",
    "1937",
    "1938",
    "1939",
    "1940",
    "1941",
    "1942",
    "1943",
    "1944",
    "1945",
    "1946",
    "1947",
    "1948",
    "1949",
    "1950",
    "1951",
    "1952",
    "1953",
    "1954",
    "1955",
    "1956",
    "1957",
    "1958",
    "1959",
    "1960",
    "1961",
    "1962",
    "1963",
    "1964",
    "1965",
    "1966",
    "1967",
    "1968",
    "1969",
    "1970",
    "1971",
    "1972",
    "1973",
    "1974",
    "1975",
    "1976",
    "1977",
    "1978",
    "1979",
    "1980",
    "1981",
    "1982",
    "1983",
    "1984",
    "1985",
    "1986",
    "1987",
    "1988",
    "1989",
    "1990",
    "1991",
    "1992",
    "1993",
    "1994",
    "1995",
    "1996",
    "1997",
    "1998",
    "1999",
    "2000",
    "2001",
    "2002",
    "2003",
    "2004",
    "2005",
    "2006",
    "2007",
    "2008",
    "2009",
    "2010",
    "2011",
    "2012",
    "2013",
    "2014",
    "2015",
    "2016",
    "2017",
    "2018",
    "2019",
    "2020",
    "2021",
    "2022",
    "2023",
    "2024",
    "2025",
    "2026"
  ];
  final List<String> isOwner = [
    "المالك",
    "وكيل",
  ];
  final List<String> paymentMethods = [
    "كاش",
    "تقسيط",
    "كاش أو تقسيط",
  ];
  final List<String> addOns = [
    "نظام الفرامل ABS",
    "نظام النقطة العمياء",
    "مراقب ضغط الإطارات",
    "قفل مركزي",
    "مقاعد كهربائية",
    "دخول بدون مفتاح",
    "مقاعد مساج",
    "مقاعد مدفئة",
    "مقود مدفئ",
    "مثبت سرعة",
    "فتحة سقف",
    "سقف بانورامي",
    "وسائد هوائية",
    "نظام بلوتوث",
    "مرايا كهربائية",
  ];

  final List<String> fuelTypes = [
    "بنزين",
    "كهرباء",
    "غاز طبيعى",
    "ديزل",
    "هيبرد",
  ];
  final List<String> transmissions = [
    "اتوماتيك",
    "يدوى/عادى",
  ];
  final List<String> saleOrRentChoices = [
    "بيع",
    "إيجار",
  ];
  final List<String> newOrUsedChoices = [
    "جديد",
    "مستعمل",
  ];
  final List<String> dollarOrLera = [
    "دولار",
    "ليره",
  ];
  void _scrollToFirstInvalidField() {
    final invalidFields = [
      if (_selectedBrand == null) _fieldKeys['brand'],
      if (_selectedImported == null)
        _fieldKeys['imported'], /////////////////////////////////
      if (_selectedBumper == null)
        _fieldKeys['bumber'], /////////////////////////////////
      if (_versionController.text.isEmpty) _fieldKeys['version'],
      if (_modelController.text.isEmpty) _fieldKeys['model'],
      if (_horsePowerController.text.isEmpty)
        _fieldKeys['horsePower'], //////////////////////
      if (_engineCapacityController.text.isEmpty)
        _fieldKeys['engineCapacity'], /////////////////////
      if (_colorController.text.isEmpty) _fieldKeys['color'],
      if (_doorsController.text.isEmpty) _fieldKeys['doors'],
      if (_innerPartController.text.isEmpty) _fieldKeys['interior'],
      if (_selectedseats == null) _fieldKeys['seats'],
      if (_selectedCarType.isEmpty) _fieldKeys['condition'],
      if (_owner.isEmpty) _fieldKeys['owner'],
      if (_selectedSaleOrRent.isEmpty) _fieldKeys['saleType'],
      if (_adTitleController.text.isEmpty) _fieldKeys['adTitle'],
      if (_descriptionController.text.isEmpty) _fieldKeys['description'],
      if (_selectedCity == null) _fieldKeys['city'],
      if (_locationController.text.isEmpty) _fieldKeys['location'],
      if (_selectedPaymentMethod.isEmpty) _fieldKeys['payment'],
      if (_priceController.text.isEmpty) _fieldKeys['price'],
      if (_selectedFuelType.isEmpty) _fieldKeys['fuel'],
      if (_selectedTransmission.isEmpty) _fieldKeys['transmission'],
      if (_kilometerController.text.isEmpty) _fieldKeys['mileage'],
      if (_nameController.text.isEmpty) _fieldKeys['name'],
      if (_phoneController.text.isEmpty) _fieldKeys['phone'],
      if (_selectedYears == null) _fieldKeys['years'], //////////////////////
      if (_selectedYears == null) _fieldKeys['years'],
      if (_phoneController.text.isEmpty) _fieldKeys['phone'],
    ];

    if (invalidFields.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Scrollable.ensureVisible(
          invalidFields.first!.currentContext!,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          alignment: 0.1,
        );
      });
    }
  }

  @override
  void dispose() {
    _adTitleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _kilometerController.dispose();
    _sypController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        cacheExtent: 10000,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        children: [
          UploadPhotosSection(
            images: _images,
            onImagesUpload: (images) {
              setState(() {
                _images.clear();
                _images.addAll(images);
              });
            },
          ),
          const SizedBox(height: 25),
          Text(
            'الماركة',
            style: TextStyle(
              color: Theme.of(context).focusColor,
              fontSize: 16,
              fontFamily: 'Noor',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          CustomDropdown(
            key: _fieldKeys['brand'],
            selectedValue: _selectedBrand,
            hint: "اختار ماركة السيارة ...",
            carOptions: AppConstants.cars,
            onChanged: (brand) => setState(() => _selectedBrand = brand!),
          ),
          const SizedBox(height: 25),
          ChipSection(
            key: _fieldKeys['saleType'],
            title: 'بيع/ايجار',
            items: saleOrRentChoices,
            selectedItems: [_selectedSaleOrRent],
            onSelect: (choice) => setState(() => _selectedSaleOrRent = choice),
          ),
          const SizedBox(height: 25),
          NumberField(
            key: _fieldKeys['mileage'],
            title: 'كيلومترات',
            validator: (value) =>
                value!.isEmpty ? 'من فضلك ادخل كيلومترات السيارة' : null,
            controller: _kilometerController,
            metric: 'Kms',
          ),

          // const SizedBox(height: 25),
          // CustomLabeledTextField(
          //   key: _fieldKeys['version'],
          //   controller: _versionController,
          //   validator: (value) =>
          //       value!.isEmpty ? 'من فضلك ادخل نسخة السيارة' : null,
          //   label: 'نسخة السيارة',
          //   hint: "نسخة السيارة",
          // ),
          const SizedBox(height: 25),
          CustomLabeledTextField(
            key: _fieldKeys['model'],
            controller: _modelController,
            keyboardType: TextInputType.number,
            validator: (value) =>
                value!.isEmpty ? 'من فضلك ادخل موديل السيارة' : null,
            label: 'موديل السيارة',
            hint: "موديل السيارة",
          ),

          const SizedBox(height: 25),
          Text(
            'سنة الصنع',
            style: TextStyle(
              color: Theme.of(context).focusColor,
              fontSize: 16,
              fontFamily: 'Noor',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          // CustomDropdown(
          //   key: _fieldKeys['years'],
          //   selectedValue: _selectedYears,
          //   hint: "السنة....",
          //   carOptions: AppConstants.cars,
          //   onChanged: (years) => setState(() => _selectedYears = years!),
          // ),
          CustomDropdown(
            key: _fieldKeys['years'],
            selectedValue: _selectedYears,
            hint: 'السنة....',
            options: years,
            onChanged: (years) => setState(() => _selectedYears = years!),
          ),
          const SizedBox(height: 25),
          CustomLabeledTextField(
            key: _fieldKeys['horsePower'],
            controller: _horsePowerController,
            keyboardType: TextInputType.number,
            validator: (value) =>
                value!.isEmpty ? 'من فضلك ادخل قوة الحصان للسيارة' : null,
            label: 'قوة الحصان',
            hint: "أدخل قوة الحصان",
          ),
          const SizedBox(height: 25),
          CustomLabeledTextField(
            key: _fieldKeys['engineCapacity'],
            controller: _engineCapacityController,
            keyboardType: TextInputType.number,
            validator: (value) =>
                value!.isEmpty ? 'من فضلك ادخل سعة المحرك للسيارة' : null,
            label: 'سعة المحرك CC',
            hint: "سعة المحرك",
          ),
          const SizedBox(height: 25),
          CustomLabeledTextField(
            key: _fieldKeys['color'],
            controller: _colorController,
            validator: (value) =>
                value!.isEmpty ? 'من فضلك ادخل لون السيارة' : null,
            label: 'لون السيارة',
            hint: "لون السيارة",
          ),
          const SizedBox(height: 25),
          Text(
            'الدفع',
            style: TextStyle(
              color: Theme.of(context).focusColor,
              fontSize: 16,
              fontFamily: 'Noor',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          CustomDropdown(
            key: _fieldKeys['bumber'],
            selectedValue: _selectedBumper,
            hint: 'اختر نوع الدفع',
            options: const ["أمامي", "خلفي", "رباعي"],
            onChanged: (bumber) => setState(() => _selectedBumper = bumber!),
          ),
          const SizedBox(height: 25),
          Text(
            'الوارد',
            style: TextStyle(
              color: Theme.of(context).focusColor,
              fontSize: 16,
              fontFamily: 'Noor',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          CustomDropdown(
            key: _fieldKeys['imported'],
            selectedValue: _selectedImported,
            hint: 'الوارد',
            options: const ["أمريكا", "اليابان", "أوروبا", "كندا", "الخليج"],
            onChanged: (imported) =>
                setState(() => _selectedImported = imported!),
          ),
          const SizedBox(height: 25),
          // CustomLabeledTextField(
          //   key: _fieldKeys['doors'],
          //   controller: _doorsController,
          //   keyboardType: TextInputType.number,
          //   validator: (value) =>
          //       value!.isEmpty ? 'من فضلك ادخل عدد الابواب' : null,
          //   label: 'عدد الابواب',
          //   hint: "عدد الابواب",
          // ),
          // const SizedBox(height: 25),
          // CustomLabeledTextField(
          //   key: _fieldKeys['interior'],
          //   controller: _innerPartController,
          //   validator: (value) =>
          //       value!.isEmpty ? 'من فضلك ادخل الجزء الداخلى' : null,
          //   label: 'الجزء الداخلى',
          //   hint: "الجزء الداخلى",
          // ),
          // const SizedBox(height: 25),
          NumbersSection(
            key: _fieldKeys['seats'],
            title: 'عدد المقاعد',
            maxNumbers: 7,
            selectedNumber: _selectedseats ?? 0,
            onSelect: (seats) => setState(() => _selectedseats = seats),
          ),
          const SizedBox(height: 25),
          ChipSection(
            key: _fieldKeys['condition'],
            title: 'جديد/مستعمل',
            items: newOrUsedChoices,
            selectedItems: [_selectedCarType],
            onSelect: (choice) => setState(() => _selectedCarType = choice),
          ),
          const SizedBox(height: 25),
          CheckBoxesSection(
            key: _fieldKeys['addons'],
            title: 'إضافات',
            isList: true,
            items: addOns,
            selectedItems: _selectedAddOns,
            onChanged: (addOn) {
              setState(() {
                _selectedAddOns.contains(addOn)
                    ? _selectedAddOns.remove(addOn)
                    : _selectedAddOns.add(addOn);
              });
            },
          ),
          const SizedBox(height: 25),
          CheckBoxesSection(
            key: _fieldKeys['fuel'],
            title: 'نوع الوقود',
            isList: true,
            items: fuelTypes,
            selectedItems: [_selectedFuelType],
            onChanged: (fuelType) {
              setState(() {
                _selectedFuelType =
                    _selectedFuelType == fuelType ? '' : fuelType;
              });
            },
          ),
          const SizedBox(height: 25),
          CheckBoxesSection(
            key: _fieldKeys['transmission'],
            title: 'ناقل الحركة',
            isList: true,
            items: transmissions,
            selectedItems: [_selectedTransmission],
            onChanged: (transmission) {
              setState(() {
                _selectedTransmission =
                    _selectedTransmission == transmission ? '' : transmission;
              });
            },
          ),
          const SizedBox(height: 25),

          SizedBox(
            height: 400,
            child: Column(
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
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 15,

                    // padding: const EdgeInsets.all(2),
                    children: [
                      ...carTypes.map(
                        (car) => _buildCarCard(
                          car['label']!,
                          car['image']!,
                          onSelect: (value) {
                            setState(() {
                              selectedCarTypeeee = value;
                            });
                            print("Selected: $value");
                          },
                        ),
                      ),
                      _buildOtherCard(context, (value) {
                        setState(() {
                          selectedCarTypeeee = value;
                        });
                        print("Selected from others: $value");
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          CheckBoxesSection(
            key: _fieldKeys['owner'],
            title: 'تم النشر الإعلان من قبل',
            items: isOwner,
            selectedItems: [_owner],
            onChanged: (status) {
              setState(() {
                _owner = _owner == status ? '' : status;
              });
            },
          ),

          const SizedBox(height: 25),
          CustomLabeledTextField(
            key: _fieldKeys['adTitle'],
            controller: _adTitleController,
            validator: (value) =>
                value!.isEmpty ? 'من فضلك ادخل عنوان الاعلان' : null,
            label: 'عنوان الاعلان',
            hint: "ادخل عنوان الاعلان",
          ),
          const SizedBox(height: 25),
          CustomLabeledTextField(
            key: _fieldKeys['description'],
            controller: _descriptionController,
            validator: (value) =>
                value!.isEmpty ? 'من فضلك ادخل وصف الاعلان' : null,
            label: 'وصف الاعلان',
            hint: "الوصف",
            maxLines: 4,
          ),
          const SizedBox(height: 25),
          InkWell(
            onTap: () async {
              final locationData = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MultiBlocProvider(
                    providers: [
                      BlocProvider(create: (context) => locator<NewAdCubit>())
                    ],
                    child: const GoogleMapScreen(),
                  ),
                ),
              );

              if (locationData != null) {
                setState(() {
                  _locationController.text = locationData['address'] ??
                      "${locationData['lat']}, ${locationData['lng']}";
                  lat = locationData['lat'] is double
                      ? locationData['lat']
                      : double.tryParse(locationData['lat'].toString());
                  long = locationData['lng'] is double
                      ? locationData['lng']
                      : double.tryParse(locationData['lng'].toString());
                });
              }
            },
            child: CustomLabeledTextField(
              key: _fieldKeys['location'],
              enabled: false,
              controller: _locationController,
              validator: (value) => value!.isEmpty ? 'ادخل موقع السيارة' : null,
              label: 'موقع السيارة',
              hint: "ادخل موقع السيارة",
              suffix: const Icon(Icons.location_on),
            ),
          ),
          const SizedBox(height: 25),
          Text(
            'المحافظة',
            style: TextStyle(
              color: Theme.of(context).focusColor,
              fontSize: 16,
              fontFamily: 'Noor',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),

          CustomDropdown(
            key: _fieldKeys['city'],
            selectedValue: _selectedCity,
            hint: 'اختر المحافظة',
            options: AppConstants.cityLists,
            onChanged: (city) => setState(() => _selectedCity = city!),
          ),
          const SizedBox(height: 25),
          CustomLabeledTextField(
            key: _fieldKeys['price'],
            controller: _priceController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) =>
                value!.isEmpty ? 'من فضلك ادخل سعر السيارة' : null,
            label: 'سعر السيارة',
            hint: _dollarOrLera != 'دولار'
                ? "ادخل سعر السيارة ... SYP"
                : "ادخل سعر السيارة ... USD",
          ),
          const SizedBox(height: 10),
          CustomCheckBox(
            text: "قابل للتفاوض",
            isChecked: _negotiable,
            onChanged: (value) => setState(() => _negotiable = value!),
          ),

          const SizedBox(height: 25),
          CheckBoxesSection(
            key: _fieldKeys['payment'],
            title: 'طريقة الدفع',
            items: paymentMethods,
            selectedItems: [_selectedPaymentMethod],
            onChanged: (paymentMethod) {
              setState(() {
                _selectedPaymentMethod = _selectedPaymentMethod == paymentMethod
                    ? ''
                    : paymentMethod;
              });
            },
          ),
          const SizedBox(height: 25),
          Text(
            "العملة",
            style: TextStyle(
              color: Theme.of(context).focusColor,
              fontSize: 16,
              fontFamily: 'Noor',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          CustomDropdown(
            key: _fieldKeys['currency'],
            selectedValue: _dollarOrLera,
            hint: "اختر العملة",
            options: const ['دولار', 'ليره'],
            onChanged: (currency) => setState(() => _dollarOrLera = currency!),
          ),
          const SizedBox(height: 25),

          Text(
            'معلومات التواصل',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Theme.of(context).focusColor,
              fontSize: 16,
              fontFamily: 'Noor',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 25),
          CustomLabeledTextField(
            key: _fieldKeys['name'],
            controller: _nameController,
            validator: (value) => value!.isEmpty ? 'من فضلك ادخل الاسم' : null,
            label: 'الاسم',
            hint: "ادخل الاسم",
          ),
          const SizedBox(height: 25),
          CustomLabeledTextField(
            key: _fieldKeys['phone'],
            controller: _phoneController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11)
            ],
            validator: (value) =>
                value!.isEmpty ? 'من فضلك ادخل رقم الهاتف' : null,
            label: 'رقم الهاتف المحمول',
            hint: "ادخل رقم الهاتف",
          ),
          const SizedBox(height: 25),
          CheckBoxesSection(
            key: _fieldKeys['contact'],
            title: 'طريقه التواصل',
            items: contactMethods,
            selectedItems: _selectedContactMethod,
            onChanged: (contactMethod) {
              setState(() {
                _selectedContactMethod.contains(contactMethod)
                    ? _selectedContactMethod.remove(contactMethod)
                    : _selectedContactMethod.add(contactMethod);
              });
            },
          ),
          const SizedBox(height: 25),
          SubmitAdButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Form is valid, proceed with submission
                _submit(context);
                // Your submission logic here
              } else {
                // Scroll to first invalid field
                _scrollToFirstInvalidField();
              }
            },
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

  void _submit(BuildContext context) {
    if (!_validate()) return;
    final ad = Ad(
      category: widget.category.id,
      currency: _dollarOrLera,
      publishedVia: _owner,
      type: _selectedCarType,
      color: _colorController.text.trim(),
      year: _modelController.text.trim(),
      horsePower: _horsePowerController.text.trim(), //////////////////
      engineCapacity: _engineCapacityController.text.trim(), ////////////
      drivetrain: _selectedBumper, ////////////////
      imported: _selectedImported, ///////////
      manufacturingYear: _selectedYears, //////////////
      carType: selectedCarTypeeee,
      doors: _doorsController.text.trim(),
      version: _versionController.text.trim(),
      innerpart: _innerPartController.text.trim(),
      seats: _selectedseats.toString(),
      listingstatus: _selectedSaleOrRent,
      city: _selectedCity,
      brand: _selectedBrand,
      adTitle: _adTitleController.text.trim(),
      description: _descriptionController.text.trim(),
      propertyLocation: _locationController.text.trim(),
      name: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      contactMethod: _selectedContactMethod,
      paymentMethod: _selectedPaymentMethod,
      price: _priceController.text.trim(),
      negotiable: _negotiable,
      imageFiles: _images,
      additionalFeatures: _selectedAddOns,
      transmissionType: _selectedTransmission,
      fuelType: [_selectedFuelType],
      kilometers: _kilometerController.text.trim(),
      downPayment: _sypController.text.trim(),
      user: UserHelper.user?.id,
      lat: lat,
      long: long,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    log(ad.toJson().toString());
    context.read<NewAdCubit>().submitAd(ad: ad);
  }

  bool _validate() {
    if (_images.length < 5) {
      AppMessages.showError(context, 'ادخل علي الاقل 5 صور للإعلان');
      return false;
    }
    if (_adTitleController.text.length < 5) {
      AppMessages.showError(context, 'ادخل علي ما بين 5 و 20 حرف للعنوان');
      return false;
    }
    if (_adTitleController.text.length > 20) {
      AppMessages.showError(context, 'ادخل ما بين 5 و 20 حرف للعنوان');
      return false;
    }

    if (_descriptionController.text.length < 20) {
      AppMessages.showError(context, 'ادخل علي الاقل 20 حرف للوصف');
      return false;
    }
    if (_selectedPaymentMethod.isEmpty) {
      AppMessages.showError(context, 'ادخل طريقه الدفع');
      return false;
    }
    if (_selectedCity == null) {
      AppMessages.showError(context, 'اختر المحافظة');
      return false;
    }
    if (_selectedYears == null) {
      AppMessages.showError(context, 'اختر سنة الصنع');
      return false;
    }
    if (_selectedBumper == null) {
      AppMessages.showError(context, 'اختر قوة الدفع');
      return false;
    }
    if (_selectedImported == null) {
      AppMessages.showError(context, 'اختر الوارد');
      return false;
    }
    if (_dollarOrLera.isEmpty) {
      AppMessages.showError(context, 'اختر العملة');
      return false;
    }
    if (_selectedCarType.isEmpty) {
      AppMessages.showError(context, 'اختر بيع / مستعمل');
      return false;
    }
    if (_selectedseats == 0) {
      AppMessages.showError(context, 'اختر عدد المقاعد');
      return false;
    }
    if (_selectedAddOns.isEmpty) {
      AppMessages.showError(context, 'اختر الإضافات');
      return false;
    }
    if (_selectedFuelType.isEmpty) {
      AppMessages.showError(context, 'اختر نوع الوقود');
      return false;
    }
    if (_selectedTransmission.isEmpty) {
      AppMessages.showError(context, 'اختر نوع الناقل');
      return false;
    }

    if (_selectedContactMethod.isEmpty) {
      AppMessages.showError(context, 'ادخل طريقه التواصل');
      return false;
    }

    return _formKey.currentState!.validate();
  }

  Widget _buildCarCard(String label, String imagePath,
      {required void Function(String) onSelect}) {
    return GestureDetector(
      onTap: () => onSelect(label),
      child: Card(
        surfaceTintColor: Colors.transparent,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.black),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(imagePath),
              const SizedBox(height: 8),
              Text(
                label,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtherCard(BuildContext context, void Function(String) onSelect) {
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
                          onSelect(moreCarTypes[index]); // ✅ return selected
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
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.black),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.more_horiz, size: 30),
              SizedBox(height: 8),
              Text("غير ذلك", style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
