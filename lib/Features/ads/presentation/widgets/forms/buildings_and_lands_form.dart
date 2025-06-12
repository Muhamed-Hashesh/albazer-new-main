import 'dart:developer';
import 'dart:io';

import 'package:albazar_app/Features/ads/data/models/ad.dart';
import 'package:albazar_app/Features/ads/presentation/cubit/new_ad_cubit.dart';
import 'package:albazar_app/Features/ads/presentation/view/google_map_screen.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/check_boxes_section.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/chip_section.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/custom_check_box.dart';
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

class BuildingsAndLandsForm extends StatefulWidget {
  final Category category;
  const BuildingsAndLandsForm({super.key, required this.category});

  @override
  State<BuildingsAndLandsForm> createState() => _BuildingsAndLandsFormState();
}

class _BuildingsAndLandsFormState extends State<BuildingsAndLandsForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, GlobalKey> _fieldKeys = {
    'landType': GlobalKey(),
    'area': GlobalKey(),
    'inOrOut': GlobalKey(),
    'owner': GlobalKey(),
    'saleOrRent': GlobalKey(),
    'adTitle': GlobalKey(),
    'description': GlobalKey(),
    'city': GlobalKey(),
    'location': GlobalKey(),
    'currency': GlobalKey(),
    'paymentMethod': GlobalKey(),
    'price': GlobalKey(),
    'name': GlobalKey(),
    'phone': GlobalKey(),
  };
  final TextEditingController _areaController = TextEditingController(),
      _adTitleController = TextEditingController(),
      _descriptionController = TextEditingController(),
      _locationController = TextEditingController(),
      _priceController = TextEditingController(),
      _nameController = TextEditingController(),
      _phoneController = TextEditingController();
  final List<File> _images = [];
  String _selectedLandType = '',
      _selectedSaleOrRent = '',
      _selectedInOrOut = '',
      _owner = '',
      _selectedPaymentMethod = '';
  bool _negotiable = false;
  double? lat;
  double? long;

  List<String> _selectedContactMethod = [];
  final List<String> landTypes = [
    "زراعية",
    "تجارية",
    "صناعية",
    "سكنية",
  ];
  // final List<String> furnitureChoices = [
  //   "نعم",
  //   "لا",
  // ];
  // final List<String> rentRates = [
  //   "يوميا",
  //   "اسبوعيا",
  //   "شهريا",
  // ];
  final List<String> contactMethods = [
    "موبايل",
    "شات",
  ];
  final List<String> saleOrRentChoices = [
    "بيع",
    "إيجار",
  ];
  final List<String> dollarOrLera = [
    "دولار",
    "ليره",
  ];
  // final List<String> buildingStatus = [
  //   "جاهز",
  //   "قيد الإنشاء",
  // ];
  // final List<String> deliveryTerms = [
  //   "متشطب",
  //   "بدون تشطيب",
  //   "نصف تشطيب",
  // ];
  final List<String> paymentMethods = [
    "كاش",
    "تقسيط",
    "كاش أو تقسيط",
  ];
  final List<String> inOrOut = [
    "داخل تنظيم",
    "خارج تنظيم",
  ];
  final List<String> isOwner = [
    "المالك",
    "وكيل",
  ];
  String _dollarOrLera = 'ليره';
  String? _selectedCity;
  void _scrollToFirstInvalidField() {
    final invalidFields = [
      if (_selectedLandType.isEmpty) _fieldKeys['landType'],
      if (_areaController.text.isEmpty) _fieldKeys['area'],
      if (_selectedInOrOut.isEmpty) _fieldKeys['inOrOut'],
      if (_owner.isEmpty) _fieldKeys['owner'],
      if (_selectedSaleOrRent.isEmpty) _fieldKeys['saleOrRent'],
      if (_adTitleController.text.isEmpty) _fieldKeys['adTitle'],
      if (_descriptionController.text.isEmpty) _fieldKeys['description'],
      if (_selectedCity == null) _fieldKeys['city'],
      if (_locationController.text.isEmpty) _fieldKeys['location'],
      if (_selectedPaymentMethod.isEmpty) _fieldKeys['paymentMethod'],
      if (_priceController.text.isEmpty) _fieldKeys['price'],
      if (_nameController.text.isEmpty) _fieldKeys['name'],
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
    _areaController.dispose();
    _adTitleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _nameController.dispose();
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
            key: _fieldKeys['landType'],
            title: 'النوع',
            items: landTypes,
            selectedItems: [_selectedLandType],
            onChanged: (landType) {
              setState(() {
                _selectedLandType =
                    _selectedLandType == landType ? '' : landType;
              });
            },
          ),
          const SizedBox(height: 25),
          ChipSection(
            key: _fieldKeys['saleOrRent'],
            title: 'بيع/ايجار',
            items: saleOrRentChoices,
            selectedItems: [_selectedSaleOrRent],
            onSelect: (choice) {
              setState(() {
                _selectedSaleOrRent =
                    _selectedSaleOrRent == choice ? '' : choice;
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
            validator: (adTitle) =>
                adTitle!.isEmpty ? 'ادخل عنوان الاعلان' : null,
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
                      BlocProvider(create: (context) => locator<NewAdCubit>()),
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
            onChanged: (currency) => setState(() => _dollarOrLera = currency!),
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
          CheckBoxesSection(
            key: _fieldKeys['paymentMethod'],
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
      city: _selectedCity,
      publishedVia: _owner,
      adTitle: _adTitleController.text.trim(),
      description: _descriptionController.text.trim(),
      area: num.parse(_areaController.text.trim()),
      regulationStatus: _selectedInOrOut,
      propertyType: _selectedLandType,
      propertyLocation: _locationController.text.trim(),
      name: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      contactMethod: _selectedContactMethod,
      paymentMethod: _selectedPaymentMethod,
      price: _priceController.text.trim(),
      negotiable: _negotiable,
      imageFiles: _images,
      listingstatus: _selectedSaleOrRent,
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
    if (_selectedLandType.isEmpty) {
      AppMessages.showError(context, 'ادخل نوع العقار');
      return false;
    }
    if (_dollarOrLera.isEmpty) {
      AppMessages.showError(context, 'اختر العملة');
      return false;
    }
    if (_selectedInOrOut.isEmpty) {
      AppMessages.showError(context, 'اختر داخل / خارج تنظيم');
      return false;
    }
    if (_selectedSaleOrRent.isEmpty) {
      AppMessages.showError(context, 'ادخل البيع أو الإيجار');
      return false;
    }
    if (_selectedCity == null) {
      AppMessages.showError(context, 'اختر المحافظة');
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
