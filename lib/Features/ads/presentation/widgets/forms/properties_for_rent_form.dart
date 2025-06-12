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

class PropertiesForRentForm extends StatefulWidget {
  final Category category;
  const PropertiesForRentForm({super.key, required this.category});

  @override
  State<PropertiesForRentForm> createState() => _PropertiesForRentFormState();
}

class _PropertiesForRentFormState extends State<PropertiesForRentForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _adTitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _feesController = TextEditingController();
  final TextEditingController _insuranceController = TextEditingController();
  final TextEditingController _buildingAgeontroller = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Keys for scrolling to invalid fields
  final GlobalKey _areaKey = GlobalKey();
  final GlobalKey _floorKey = GlobalKey();
  final GlobalKey _adTitleKey = GlobalKey();
  final GlobalKey _descriptionKey = GlobalKey();
  final GlobalKey _locationKey = GlobalKey();
  final GlobalKey _feesKey = GlobalKey();
  final GlobalKey _insuranceKey = GlobalKey();
  final GlobalKey _buildingAgeKey = GlobalKey();
  final GlobalKey _nameKey = GlobalKey();
  final GlobalKey _phoneKey = GlobalKey();
  final GlobalKey _cityKey = GlobalKey();
  final GlobalKey _floor = GlobalKey();///////////////
  final GlobalKey _floorNum = GlobalKey();////////////
  final GlobalKey _rooms = GlobalKey();
  final GlobalKey _salons = GlobalKey();/////////////
  final GlobalKey _bathrooms = GlobalKey();
  final GlobalKey _age = GlobalKey();
  final List<File> _images = [];
  String _selectedBuilding = '',
      _selectedRentRate = '',
      _owner = '',
      _selectedInOrOut = '',
      _selectedChoice = '';
  final List<String> _selectedLuxuries = [];
  final List<String> _selectedContactMethod = [];

  bool _negotiable = false;
  double? lat;
  double? long;
  String? selectedBuildingAge;

  int _selectedRoom = 0, _selectedBathroom = 0, _selectedSalons = 0;

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

  String _dollarOrLera = 'ليره';
  String? _selectedFloorNum;
  String? _selectedFloor;
  String? _selectedDeed;
  String? _selectedCity;
  String? _selectedBuildingAge;
  void _scrollToFirstInvalidField() {
    final fieldsToValidate = [
      if (_selectedBuilding.isEmpty) _areaKey,
      if (_areaController.text.isEmpty) _areaKey,
      if (_floorController.text.isEmpty) _floorKey,
      if (_selectedInOrOut.isEmpty) _areaKey,
      if (_adTitleController.text.isEmpty) _adTitleKey,
      if (_descriptionController.text.isEmpty) _descriptionKey,
      if (_selectedCity == null) _cityKey,
      if (_selectedFloor == null) _floor,
      if (_selectedFloorNum == null) _floorNum,
      if (_locationController.text.isEmpty) _locationKey,
      if (_selectedRentRate.isEmpty) _areaKey,
      if (_feesController.text.isEmpty) _feesKey,
      if (_insuranceController.text.isEmpty) _insuranceKey,
      if (selectedBuildingAge == null) _buildingAgeKey,
      if (_nameController.text.isEmpty) _nameKey,
      if (_phoneController.text.isEmpty) _phoneKey,
      if (_selectedContactMethod.isEmpty) _areaKey,
      if (_selectedFloor == null) _floor,//////
      if (_selectedFloorNum == null) _floorNum,//////
    ];

    if (fieldsToValidate.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Scrollable.ensureVisible(
          fieldsToValidate.first.currentContext!,
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
    _floorController.dispose();
    _adTitleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _feesController.dispose();
    _insuranceController.dispose();
    _buildingAgeontroller.dispose();
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
            },
          ),
          const SizedBox(height: 25),
          CheckBoxesSection(
            title: 'داخل / خارج تنظيم',
            items: inOrOut,
            selectedItems: [_selectedInOrOut],
            onChanged: (status) {
              setState(() {
                if (_selectedInOrOut == status) {
                  _selectedInOrOut = '';
                  return;
                }
                _selectedInOrOut = status;
              });
            },
          ),
          const SizedBox(height: 25),
          CustomLabeledTextField(
            key: _areaKey,
            controller: _areaController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (area) {
              if (area!.isEmpty) {
                return 'ادخل مساحة العقار';
              }
              return null;
            },
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
            key: _floor,
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
            key: _floorNum,
            selectedValue: _selectedFloorNum,
            hint: 'ادخل عدد الطوابق ...',
            options: floor,
            onChanged: (floorNum) =>
                setState(() => _selectedFloorNum = floorNum!),
          ),
          NumbersSection(
            key: _rooms,
            title: 'عدد الغرف',
            maxNumbers: 7,
            selectedNumber: _selectedRoom,
            onSelect: (room) => setState(() => _selectedRoom = room),
          ),
          const SizedBox(height: 25),
          NumbersSection(
            key: _salons,
            title: 'عدد الصالونات',
            maxNumbers: 5,
            selectedNumber: _selectedSalons,
            onSelect: (salon) => setState(() => _selectedSalons = salon),
          ),
          const SizedBox(height: 25),
          NumbersSection(
            key: _bathrooms,
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
            key: _age,
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
          const SizedBox(height: 25),

          CheckBoxesSection(
              title: 'تم النشر من قبل ',
              items: isOwner,
              selectedItems: [_owner],
              onChanged: (status) {
                setState(() {
                  if (_owner == status) {
                    _owner = '';
                    return;
                  }
                  _owner = status;
                });
              }),
          const SizedBox(
            height: 25,
          ),
          ChipSection(
            title: 'الكماليات',
            items: luxuries,
            selectedItems: _selectedLuxuries,
            onSelect: (luxury) {
              setState(() {
                if (_selectedLuxuries.contains(luxury)) {
                  _selectedLuxuries.remove(luxury);
                } else {
                  _selectedLuxuries.add(luxury);
                }
              });
            },
          ),

          const SizedBox(height: 25),
          CustomLabeledTextField(
            key: _adTitleKey,
            controller: _adTitleController,
            validator: (title) {
              if (title!.isEmpty) {
                return 'ادخل عنوان الاعلان';
              }
              return null;
            },
            label: 'عنوان الاعلان',
            hint: "ادخل عنوان الاعلان",
          ),
          const SizedBox(height: 25),
          CustomLabeledTextField(
            key: _descriptionKey,
            controller: _descriptionController,
            validator: (description) {
              if (description!.isEmpty) {
                return 'ادخل وصف الاعلان';
              }
              return null;
            },
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
            key: _cityKey,
            selectedValue: _selectedCity,
            hint: 'اختر المحافظة',
            options: AppConstants.cityLists,
            onChanged: (city) {
              setState(() {
                _selectedCity = city!;
              });
            },
          ),
          const SizedBox(height: 25),
          InkWell(
            onTap: () async {
              final locationData = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => locator<NewAdCubit>(),
                      ),
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
              key: _locationKey,
              enabled: false,
              controller: _locationController,
              validator: (location) {
                if (location!.isEmpty) {
                  return 'ادخل موقع العقار';
                }
                return null;
              },
              label: 'موقع العقار',
              hint: "ادخل موقع العقار",
              suffix: const Icon(Icons.location_on),
            ),
          ),
          const SizedBox(height: 25),
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
            selectedValue: _dollarOrLera,
            hint: "اختر العملة",
            options: const ['دولار', 'ليره'],
            onChanged: (currency) {
              setState(() {
                _dollarOrLera = currency!;
              });
            },
          ),
          const SizedBox(height: 25),
          CustomLabeledTextField(
            key: _feesKey,
            controller: _feesController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (fees) {
              if (fees!.isEmpty) {
                return 'ادخل رسوم الايجار';
              }
              return null;
            },
            label: 'رسوم الايجار',
            hint: "ادخل رسوم الايجار",
          ),
          const SizedBox(height: 10),
          CustomCheckBox(
            text: "قابل للتفاوض",
            isChecked: _negotiable,
            onChanged: (value) {
              setState(() {
                _negotiable = value!;
              });
            },
          ),
          const SizedBox(height: 25),
          CustomLabeledTextField(
            key: _insuranceKey,
            controller: _insuranceController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (insurance) {
              if (insurance!.isEmpty) {
                return 'ادخل مبلغ التاءمين';
              }
              return null;
            },
            label: 'التأمين',
            hint: "أدخل مبلغ التأمين",
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
            key: _nameKey,
            controller: _nameController,
            validator: (name) {
              if (name!.isEmpty) {
                return 'ادخل الاسم';
              }
              return null;
            },
            label: 'الاسم',
            hint: "ادخل الاسم",
          ),
          const SizedBox(height: 25),
          CustomLabeledTextField(
            key: _phoneKey,
            controller: _phoneController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11)
            ],
            validator: (phone) {
              if (phone!.isEmpty) {
                return 'ادخل رقم الهاتف المحمول';
              }
              return null;
            },
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
                if (_selectedContactMethod.contains(contactMethod)) {
                  _selectedContactMethod.remove(contactMethod);
                } else {
                  _selectedContactMethod.add(contactMethod);
                }
              });
            },
          ),
          const SizedBox(height: 25),
          SubmitAdButton(onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Form is valid, proceed with submission
              _submit(context);
              // Your submission logic here
            } else {
              // Scroll to first invalid field
              _scrollToFirstInvalidField();
            }
          }),
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
      year: selectedBuildingAge,
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
      rentalRate: _selectedRentRate,
      rentalFees: _feesController.text.trim(),
      amenities: _selectedLuxuries,
      name: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      contactMethod: _selectedContactMethod,
      securityDeposit: num.parse(_insuranceController.text.trim()),
      negotiable: _negotiable,
      furnishing: _selectedChoice == furnitureChoices.first,
      numberOfBathrooms: _selectedBathroom,
      numberOfRooms: _selectedRoom,
       deed: _selectedDeed,
      imageFiles: _images,
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
      AppMessages.showError(context, 'ادخل على الاقل 5 صور للإعلان');
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
    if (_dollarOrLera.isEmpty) {
      AppMessages.showError(context, 'اختر العملة');
      return false;
    }
    if (_selectedCity == null) {
      AppMessages.showError(context, 'اختر المحافظة');
      return false;
    }
         if (_selectedFloor == null) {
      AppMessages.showError(context, 'اختر الطابق');
      return false;
    }
     if (_selectedFloorNum == null) {
      AppMessages.showError(context, 'اختر عدد الطوابق');
         return false;
    }
    if (_selectedLuxuries.isEmpty) {
      AppMessages.showError(context, 'ادخل الكماليات');
      return false;
    }
    if (_selectedInOrOut.isEmpty) {
      AppMessages.showError(context, 'اختر داخل / خارج تنظيم');
      return false;
    }
    if (_selectedRoom == 0) {
      AppMessages.showError(context, 'ادخل عدد الغرف');
      return false;
    }

     if (_selectedSalons == 0) {
      AppMessages.showError(context, 'ادخل عدد الصالونات');////////////////
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

    if (_selectedRentRate.isEmpty) {
      AppMessages.showError(context, 'ادخل معدل الايجار');
      return false;
    }

    if (_selectedContactMethod.isEmpty) {
      AppMessages.showError(context, 'ادخل طريقه التواصل');
      return false;
    }

    return _formKey.currentState!.validate();
  }
}
