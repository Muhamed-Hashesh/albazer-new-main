import 'dart:developer';
import 'dart:io';

import 'package:albazar_app/Features/ads/data/models/ad.dart';
import 'package:albazar_app/Features/ads/presentation/cubit/new_ad_cubit.dart';
import 'package:albazar_app/Features/ads/presentation/view/google_map_screen.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/check_boxes_section.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/chip_section.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/custom_check_box.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/numbers_section.dart';
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

class PropertiesForSaleForm extends StatefulWidget {
  final Category category;
  const PropertiesForSaleForm({super.key, required this.category});

  @override
  State<PropertiesForSaleForm> createState() => _PropertiesForSaleFormState();
}

class _PropertiesForSaleFormState extends State<PropertiesForSaleForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, GlobalKey> _fieldKeys = {
    'building': GlobalKey(),
    'area': GlobalKey(),
    'floor': GlobalKey(), ///////
    'luxuries': GlobalKey(),
    'rooms': GlobalKey(),
    'salons': GlobalKey(), /////////////
    'bathrooms': GlobalKey(),
    'furniture': GlobalKey(),
    'inOrOut': GlobalKey(),
    'owner': GlobalKey(),
    'status': GlobalKey(),
    'delivery': GlobalKey(),
    'adTitle': GlobalKey(),
    'description': GlobalKey(),
    'city': GlobalKey(),
    'location': GlobalKey(),
    'currency': GlobalKey(),
    'payment': GlobalKey(),
    'price': GlobalKey(),
    'age': GlobalKey(),
    'name': GlobalKey(),
    'phone': GlobalKey(),
    'contact': GlobalKey(),
    'floorNum': GlobalKey(), //////////
    'deed': GlobalKey(), //////////////
  };
  final TextEditingController _areaController = TextEditingController(),
      _floorController = TextEditingController(),
      _adTitleController = TextEditingController(),
      _descriptionController = TextEditingController(),
      _locationController = TextEditingController(),
      _priceController = TextEditingController(),
      _buildingAgeontroller = TextEditingController(),
      _nameController = TextEditingController(),
      _phoneController = TextEditingController();
  final List<File> _images = [];
  String _selectedBuilding = '',
      _selectedChoice = '',
      _selectedInOrOut = '',
      // _selectedBuildingAge = '1',
      _owner = '',
      _selectedBuildingStatus = '',
      _selectedDeliveryTerm = '',
      _selectedPaymentMethod = '';
  String? _selectedBuildingAge;
  double? lat;
  double? long;
  bool _negotiable = false;
  void _scrollToFirstInvalidField() {
    final invalidFields = [
      if (_selectedBuilding.isEmpty) _fieldKeys['building'],
      if (_areaController.text.isEmpty) _fieldKeys['area'],
      // if (_floorController.text.isEmpty) _fieldKeys['floor'],
      if (_selectedInOrOut.isEmpty) _fieldKeys['inOrOut'],
      if (_owner.isEmpty) _fieldKeys['owner'],
      if (_selectedBuildingStatus.isEmpty) _fieldKeys['status'],
      if (_selectedDeliveryTerm.isEmpty) _fieldKeys['delivery'],
      if (_adTitleController.text.isEmpty) _fieldKeys['adTitle'],
      if (_descriptionController.text.isEmpty) _fieldKeys['description'],
      if (_selectedCity == null) _fieldKeys['city'],
      if (_locationController.text.isEmpty) _fieldKeys['location'],
      if (_selectedPaymentMethod.isEmpty) _fieldKeys['payment'],
      if (_priceController.text.isEmpty) _fieldKeys['price'],
      if (_selectedBuildingAge == null) _fieldKeys['age'],
      if (_nameController.text.isEmpty) _fieldKeys['name'],
      if (_phoneController.text.isEmpty) _fieldKeys['phone'],
      if (_selectedFloor == null) _fieldKeys['floor'], //////
      if (_selectedFloorNum == null) _fieldKeys['floorNum'], //////
      if (_selectedDeed == null) _fieldKeys['deed'], ////////
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

  final List<String> _selectedLuxuries = [];
  List<String> _selectedContactMethod = [];

  int _selectedRoom = 0, _selectedBathroom = 0, _selectedSalons = 0;

  final List<String> buildings = [
    "شقة",
    "فيلا",
    "بناء",
    "بيت عربي",
    // "بيت عربي",
    "محل",
    "مستودع",
    "مكتب",
    "مصنع",
    "مقهى",
  ];
  final List<String> deeds = [
    "أخضر طابو (طابو نظامي)",
    "طابو زراعي",
    "حكم محكة",
    "كاتب عدل",
  ];
  final List<String> floor = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
  ];
  final List<String> floorNum = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
  ];
  final List<String> furnitureChoices = [
    "نعم",
    "لا",
  ];
  final List<String> inOrOut = [
    "داخل تنظيم",
    "خارج تنظيم",
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
  final List<String> contactMethods = [
    "موبايل",
    "شات",
  ];
  final List<String> luxuries = [
    "مصعد",
    "طاقة شمسية",
    "تدفئة",
    "غاز مركزي",
    "أمن",
    "موقف سيارات",
    "بلكون",
    "أجهزة المطبخ",
    "حديقة خاصة",
    "حمام سباحة",
    "مدخل مستقل",
  ];
  final List<String> buildingStatus = [
    "جاهز",
    "قيد الإنشاء",
  ];
  final List<String> deliveryTerms = [
    "بدون إكساء",
    "نص إكساء",
    "إكساء ديلوكس",
  ];
  final List<String> paymentMethods = [
    "كاش",
    "تقسيط",
    "كاش أو تقسيط",
  ];
  final List<String> dollarOrLera = [
    "دولار",
    "ليره",
  ];
  String _dollarOrLera = 'ليره';
  String? _selectedCity;
  String? _selectedFloor;
  String? _selectedFloorNum;
  String? _selectedDeed;
  @override
  void dispose() {
    _areaController.dispose();
    _floorController.dispose();
    _adTitleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _nameController.dispose();
    _buildingAgeontroller.dispose();
    _phoneController.dispose();

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
            CheckBoxesSection(
              key: _fieldKeys['building'],
              title: 'نوع العقار',
              items: buildings,
              selectedItems: [_selectedBuilding],
              onChanged: (building) {
                setState(() {
                  _selectedBuilding =
                      _selectedBuilding == building ? '' : building;
                });
              },
            ),
            const SizedBox(height: 25),
            CheckBoxesSection(
              key: _fieldKeys['status'],
              title: 'حالة العقار',
              items: buildingStatus,
              selectedItems: [_selectedBuildingStatus],
              onChanged: (status) {
                setState(() {
                  _selectedBuildingStatus =
                      _selectedBuildingStatus == status ? '' : status;
                });
              },
            ),
            const SizedBox(height: 25),
            CheckBoxesSection(
              key: _fieldKeys['inOrOut'],
              title: 'داخل / خارج تنظيم',
              items: inOrOut,
              selectedItems: [_selectedInOrOut],
              onChanged: (status) {
                setState(() {
                  _selectedInOrOut = _selectedInOrOut == status ? '' : status;
                });
              },
            ),
            const SizedBox(height: 25),
            CustomLabeledTextField(
              key: _fieldKeys['area'],
              controller: _areaController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (area) => area!.isEmpty ? 'ادخل مساحة العقار' : null,
              label: 'المساحة (م٢)*',
              hint: "ادخل مساحة العقار ...",
            ),
            const SizedBox(height: 25),
            Text(
              'الطابق',
              style: TextStyle(
                color: Theme.of(context).focusColor,
                fontSize: 16,
                fontFamily: 'Noor',
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 15),
            // CustomLabeledTextField(
            //   key: _fieldKeys['floor'],
            //   controller: _floorController,
            //   keyboardType: TextInputType.number,
            //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            //   validator: (floor) => floor!.isEmpty ? 'ادخل الطابق' : null,
            //   label: 'الطابق',
            //   hint: "ادخل الطابق ...",
            // ),
            CustomDropdown(
              key: _fieldKeys['floor'],
              selectedValue: _selectedFloor,
              hint: 'ادخل الطابق ...',
              options: floor,
              onChanged: (floor) => setState(() => _selectedFloor = floor!),
            ),

            const SizedBox(height: 25),

            Text(
              'عدد الطوابق',
              style: TextStyle(
                color: Theme.of(context).focusColor,
                fontSize: 16,
                fontFamily: 'Noor',
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 15),
            CustomDropdown(
              key: _fieldKeys['floorNum'],
              selectedValue: _selectedFloorNum,
              hint: 'ادخل عدد الطوابق ...',
              options: floorNum,
              onChanged: (floorNum) =>
                  setState(() => _selectedFloorNum = floorNum!),
            ),
            const SizedBox(height: 25),
            NumbersSection(
              key: _fieldKeys['rooms'],
              title: 'عدد الغرف',
              maxNumbers: 7,
              selectedNumber: _selectedRoom,
              onSelect: (room) => setState(() => _selectedRoom = room),
            ),
            const SizedBox(height: 25),
            NumbersSection(
              key: _fieldKeys['salons'],
              title: 'عدد الصالونات',
              maxNumbers: 5,
              selectedNumber: _selectedSalons,
              onSelect: (salon) => setState(() => _selectedSalons = salon),
            ),
            const SizedBox(height: 25),
            NumbersSection(
              key: _fieldKeys['bathrooms'],
              title: 'عدد الحمامات',
              maxNumbers: 7,
              selectedNumber: _selectedBathroom,
              onSelect: (bathroom) =>
                  setState(() => _selectedBathroom = bathroom),
            ),
            const SizedBox(height: 25),
            Text(
              "عمر المبنى",
              style: TextStyle(
                color: Theme.of(context).focusColor,
                fontSize: 16,
                fontFamily: 'Noor',
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            CustomDropdown(
              key: _fieldKeys['age'],
              // label: 'عمر المبنى',
              hint: "أدخل عمر المبنى",
              selectedValue: _selectedBuildingAge,
              options: List.generate(
                101,
                (index) => '$index',
              ),
              onChanged: (value) {
                _selectedBuildingAge = value!;
              },
            ),

            const SizedBox(height: 25),
            ChipSection(
              key: _fieldKeys['furniture'],
              title: 'الفرش',
              items: furnitureChoices,
              selectedItems: [_selectedChoice],
              onSelect: (choice) {
                setState(() {
                  _selectedChoice = _selectedChoice == choice ? '' : choice;
                });
              },
            ),
            const SizedBox(height: 25),

            ChipSection(
              key: _fieldKeys['luxuries'],
              title: 'الكماليات',
              items: luxuries,
              selectedItems: _selectedLuxuries,
              onSelect: (luxury) {
                setState(() {
                  _selectedLuxuries.contains(luxury)
                      ? _selectedLuxuries.remove(luxury)
                      : _selectedLuxuries.add(luxury);
                });
              },
            ),
            const SizedBox(height: 25),
            CheckBoxesSection(
              key: _fieldKeys['delivery'],
              title: 'شروط التسليم',
              items: deliveryTerms,
              selectedItems: [_selectedDeliveryTerm],
              onChanged: (deliveryTerm) {
                setState(() {
                  _selectedDeliveryTerm =
                      _selectedDeliveryTerm == deliveryTerm ? '' : deliveryTerm;
                });
              },
            ),
            const SizedBox(height: 25),

            CheckBoxesSection(
              key: _fieldKeys['owner'],
              title: 'تم النشر من قبل',
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
              validator: (title) =>
                  title!.isEmpty ? 'ادخل عنوان الاعلان' : null,
              label: 'عنوان الاعلان',
              hint: "ادخل عنوان الاعلان",
            ),
            const SizedBox(height: 25),
            CustomLabeledTextField(
              key: _fieldKeys['description'],
              controller: _descriptionController,
              validator: (description) =>
                  description!.isEmpty ? 'ادخل وصف الاعلان' : null,
              label: 'وصف الاعلان',
              hint: "الوصف",
              maxLines: 4,
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
                validator: (location) =>
                    location!.isEmpty ? 'ادخل موقع العقار' : null,
                label: 'موقع العقار',
                hint: "ادخل موقع العقار",
                suffix: const Icon(Icons.location_on),
              ),
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
              onChanged: (currency) =>
                  setState(() => _dollarOrLera = currency!),
            ),
            const SizedBox(height: 25),
            CheckBoxesSection(
              key: _fieldKeys['payment'],
              title: 'طريقة الدفع',
              items: paymentMethods,
              selectedItems: [_selectedPaymentMethod],
              onChanged: (paymentMethod) {
                setState(() {
                  _selectedPaymentMethod =
                      _selectedPaymentMethod == paymentMethod
                          ? ''
                          : paymentMethod;
                });
              },
            ),
            const SizedBox(height: 25),
            CustomLabeledTextField(
              key: _fieldKeys['price'],
              controller: _priceController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (price) => price!.isEmpty ? 'ادخل سعر العقار' : null,
              label: 'السعر',
              hint: _dollarOrLera != 'دولار'
                  ? "ادخل سعر العقار ... SYP"
                  : "ادخل سعر العقار ... USD",
            ),
            const SizedBox(height: 10),
            CustomCheckBox(
              text: "قابل للتفاوض",
              isChecked: _negotiable,
              onChanged: (value) => setState(() => _negotiable = value!),
            ),
            const SizedBox(height: 25),
            Text(
              "الطابو",
              style: TextStyle(
                color: Theme.of(context).focusColor,
                fontSize: 16,
                fontFamily: 'Noor',
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            CustomDropdown(
              key: _fieldKeys['deed'],
              selectedValue: _selectedDeed,
              hint: "اختر الطابو",
              options: deeds,
              onChanged: (deed) => setState(() => _selectedDeed = deed!),
            ),
            const SizedBox(height: 25),
            // CustomLabeledTextField(
            //   key: _fieldKeys['age'],
            //   controller: _buildingAgeontroller,
            //   keyboardType: TextInputType.number,
            //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            //   validator: (age) => age!.isEmpty ? 'ادخل عمر المبنى' : null,
            //   label: 'عمر المبنى',
            //   hint: "أدخل عمر المبنى",
            // ),

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
              validator: (name) => name!.isEmpty ? 'ادخل الاسم' : null,
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
              validator: (phone) =>
                  phone!.isEmpty ? 'ادخل رقم الهاتف المحمول' : null,
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
                  _submit(context);
                } else {
                  _scrollToFirstInvalidField();
                  // log("errrrrrrrrrrrrrrrrrrrrrrrrrrrrrrro");
                }
              },
            ),
            const SizedBox(height: 25),
          ],
        ));
  }

  void _submit(BuildContext context) {
    if (!_validate()) return;
    final ad = Ad(
      category: widget.category.id,
      currency: _dollarOrLera,
      city: _selectedCity,
      publishedVia: _owner,
      year: _selectedBuildingAge,
      adTitle: _adTitleController.text.trim(),
      description: _descriptionController.text.trim(),
      area: num.parse(_areaController.text.trim()),
      floor:
          // _floorController.text.trim()
          _selectedFloor, //change<<<<<<
      floorNumber: _selectedFloorNum,
      regulationStatus: _selectedInOrOut,
      propertyType: _selectedBuilding,
      propertyLocation: _locationController.text.trim(),
      rentalFees: _priceController.text.trim(),
      amenities: _selectedLuxuries,
      name: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      contactMethod: _selectedContactMethod,
      paymentMethod: _selectedPaymentMethod,
      price: _priceController.text.trim(),
      negotiable: _negotiable,
      furnishing: _selectedChoice == furnitureChoices.first,
      numberOfBathrooms: _selectedBathroom,
      numberOfRooms: _selectedRoom,
      numberOfSalons: _selectedSalons,
      deed: _selectedDeed,
      imageFiles: _images,
      deliveryConditions: _selectedDeliveryTerm,
      propertyCondition: _selectedBuildingStatus,
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
    if (_selectedBuilding.isEmpty) {
      AppMessages.showError(context, 'ادخل نوع العقار');
      return false;
    }
    if (_selectedInOrOut.isEmpty) {
      AppMessages.showError(context, 'اختر داخل / خارج تنظيم');
      return false;
    }
    if (_dollarOrLera.isEmpty) {
      AppMessages.showError(context, 'اختر العملة');
      return false;
    }
    if (_selectedCity == null) {
      AppMessages.showError(context, 'اختر المحافظة');
      return false;
    }
    if (_selectedFloor == null) {
      AppMessages.showError(context, 'اختر الطابق'); ///////////
      return false;
    }
    if (_selectedFloorNum == null) {
      AppMessages.showError(context, 'اختر عدد الطوابق'); ///////////////
      return false;
    }
    if (_selectedDeed == null) {
      AppMessages.showError(context, 'اختر نوع الطابو '); ///////////////
      return false;
    }
    if (_selectedLuxuries.isEmpty) {
      AppMessages.showError(context, 'ادخل الكماليات');
      return false;
    }

    if (_selectedRoom == 0) {
      AppMessages.showError(context, 'ادخل عدد الغرف');
      return false;
    }
    if (_selectedSalons == 0) {
      AppMessages.showError(context, 'ادخل عدد الصالونات'); ////////////////
      return false;
    }

    if (_selectedBathroom == 0) {
      AppMessages.showError(context, 'ادخل عدد الحمامات');
      return false;
    }

    if (_selectedChoice.isEmpty) {
      AppMessages.showError(context, 'ادخل الفرش');
      return false;
    }

    if (_selectedBuildingStatus.isEmpty) {
      AppMessages.showError(context, 'ادخل حالة العقار');
      return false;
    }
    if (_selectedDeliveryTerm.isEmpty) {
      AppMessages.showError(context, 'ادخل شروط التسليم');
      return false;
    }

    if (_selectedPaymentMethod.isEmpty) {
      AppMessages.showError(context, 'ادخل طريقه الدفع');
      return false;
    }

    if (_selectedContactMethod.isEmpty) {
      AppMessages.showError(context, 'ادخل طريقه التواصل');
      return false;
    }

    return _formKey.currentState!.validate();
  }
}
