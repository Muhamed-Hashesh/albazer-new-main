import 'package:albazar_app/core/functions/ValidationHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:albazar_app/core/utils/styles.dart';

class CustomPhoneField extends StatefulWidget {
  final String labelText;
  final TextEditingController? controller;
  final String initialCountryCode;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final bool readOnly;
  final bool enabled;
  final bool showCountryFlag;
  final TextAlign textAlign;
  final double borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final TextDirection textDirection;
  final int? minPhoneLength;
  final int? maxPhoneLength;

  const CustomPhoneField({
    super.key,
    required this.labelText,
    this.controller,
    this.initialCountryCode = 'SY',
    this.validator,
    this.onChanged,
    this.onSaved,
    this.readOnly = false,
    this.enabled = true,
    this.showCountryFlag = true,
    this.textAlign = TextAlign.right,
    this.borderRadius = 15,
    this.contentPadding =
        const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
    this.textDirection = TextDirection.rtl,
    this.minPhoneLength,
    this.maxPhoneLength,
  });

  @override
  State<CustomPhoneField> createState() => _CustomPhoneFieldState();
}

class _CustomPhoneFieldState extends State<CustomPhoneField> {
  String selectedCountryCode = 'SY';
  String selectedDialCode = '+963';
  late TextEditingController _controller;

  // قائمة الدول مع الأعلام وعدد الأرقام
  final Map<String, Map<String, dynamic>> countries = {
    'SY': {
      'name': 'سوريا',
      'dialCode': '+963',
      'emoji': '🇸🇾',
      'minLength': 9,
      'maxLength': 9
    },
    'SA': {
      'name': 'السعودية',
      'dialCode': '+966',
      'emoji': '🇸🇦',
      'minLength': 9,
      'maxLength': 9
    },
    'AE': {
      'name': 'الإمارات',
      'dialCode': '+971',
      'emoji': '🇦🇪',
      'minLength': 9,
      'maxLength': 9
    },
    'JO': {
      'name': 'الأردن',
      'dialCode': '+962',
      'emoji': '🇯🇴',
      'minLength': 9,
      'maxLength': 9
    },
    'LB': {
      'name': 'لبنان',
      'dialCode': '+961',
      'emoji': '🇱🇧',
      'minLength': 8,
      'maxLength': 8
    },
    'EG': {
      'name': 'مصر',
      'dialCode': '+20',
      'emoji': '🇪🇬',
      'minLength': 10,
      'maxLength': 11
    },
    'IQ': {
      'name': 'العراق',
      'dialCode': '+964',
      'emoji': '🇮🇶',
      'minLength': 10,
      'maxLength': 10
    },
    'TR': {
      'name': 'تركيا',
      'dialCode': '+90',
      'emoji': '🇹🇷',
      'minLength': 10,
      'maxLength': 10
    },
    'US': {
      'name': 'أمريكا',
      'dialCode': '+1',
      'emoji': '🇺🇸',
      'minLength': 10,
      'maxLength': 10
    },
    'GB': {
      'name': 'بريطانيا',
      'dialCode': '+44',
      'emoji': '🇬🇧',
      'minLength': 10,
      'maxLength': 11
    },
    'DE': {
      'name': 'ألمانيا',
      'dialCode': '+49',
      'emoji': '🇩🇪',
      'minLength': 10,
      'maxLength': 12
    },
    'FR': {
      'name': 'فرنسا',
      'dialCode': '+33',
      'emoji': '🇫🇷',
      'minLength': 10,
      'maxLength': 10
    },
  };

  @override
  void initState() {
    super.initState();
    selectedCountryCode = widget.initialCountryCode;
    selectedDialCode = countries[selectedCountryCode]?['dialCode'] ?? '+963';
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  // Widget لبناء العلم السوري الجديد
  Widget _buildSyrianFlag() {
    return Container(
      width: 24,
      height: 16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: Colors.grey.shade300, width: 0.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: Column(
          children: [
            // الخط الأخضر
            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xFF009900), // الأخضر
              ),
            ),
            // الخط الأبيض مع النجوم
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStar(),
                    _buildStar(),
                    _buildStar(),
                  ],
                ),
              ),
            ),
            // الخط الأسود
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget لبناء النجمة الحمراء
  Widget _buildStar() {
    return Container(
      width: 4,
      height: 4,
      child: const Icon(
        Icons.star,
        color: Colors.red,
        size: 4,
      ),
    );
  }

  // Widget لبناء العلم باستخدام Emoji للدول الأخرى
  Widget _buildEmojiFlag(String emoji) {
    return Container(
      width: 24,
      height: 16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: Colors.grey.shade300, width: 0.5),
      ),
      child: Center(
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  // Widget لبناء العلم المناسب
  Widget _buildFlag(String countryCode) {
    if (countryCode == 'SY') {
      return _buildSyrianFlag();
    } else {
      String emoji = countries[countryCode]?['emoji'] ?? '🏳️';
      return _buildEmojiFlag(emoji);
    }
  }

  // إظهار قائمة اختيار الدولة
  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 500,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'اختر الدولة',
                style: Styles.style18.copyWith(
                  color: Theme.of(context).focusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: countries.length,
                  itemBuilder: (context, index) {
                    String countryCode = countries.keys.elementAt(index);
                    Map<String, dynamic> countryData = countries[countryCode]!;

                    return ListTile(
                      leading: _buildFlag(countryCode),
                      title: Text(
                        countryData['name']!,
                        style: Styles.style14.copyWith(
                          color: Theme.of(context).focusColor,
                        ),
                      ),
                      subtitle: Text(
                        '${countryData['dialCode']} • ${countryData['minLength'] == countryData['maxLength'] ? '${countryData['minLength']} أرقام' : '${countryData['minLength']}-${countryData['maxLength']} أرقام'}',
                        style: Styles.style12.copyWith(
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      selected: selectedCountryCode == countryCode,
                      selectedTileColor:
                          Theme.of(context).primaryColor.withOpacity(0.1),
                      onTap: () {
                        setState(() {
                          selectedCountryCode = countryCode;
                          selectedDialCode = countryData['dialCode']!;
                        });
                        Navigator.pop(context);
                        _updatePhoneNumber();
                        // إعادة إنشاء الحقل لتطبيق القيود الجديدة
                        setState(() {});
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // تحديث رقم الهاتف الكامل
  void _updatePhoneNumber() {
    String fullNumber = selectedDialCode + _controller.text;
    if (widget.onChanged != null) {
      widget.onChanged!(fullNumber);
    }
  }

  // الحصول على الحد الأقصى لطول الرقم
  int _getMaxLength() {
    return widget.maxPhoneLength ??
        countries[selectedCountryCode]?['maxLength'] ??
        15;
  }

  // الحصول على الحد الأدنى لطول الرقم
  int _getMinLength() {
    return widget.minPhoneLength ??
        countries[selectedCountryCode]?['minLength'] ??
        7;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 17),
      child: Directionality(
        textDirection: widget.textDirection,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _controller,
              keyboardType: TextInputType.phone,
              textAlign: widget.textAlign,
              readOnly: widget.readOnly,
              enabled: widget.enabled,
              style:
                  Styles.style13.copyWith(color: Theme.of(context).hoverColor),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(_getMaxLength()),
              ],
              onChanged: (value) {
                _updatePhoneNumber();
              },
              onSaved: widget.onSaved,
              validator: widget.validator ??
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'رقم الهاتف مطلوب';
                    }

                    int phoneLength = value.length;
                    int minLength = _getMinLength();
                    int maxLength = _getMaxLength();

                    if (phoneLength < minLength) {
                      return 'رقم الهاتف قصير جداً (الحد الأدنى $minLength أرقام)';
                    }

                    if (phoneLength > maxLength) {
                      return 'رقم الهاتف طويل جداً (الحد الأقصى $maxLength أرقام)';
                    }

                    String fullNumber = selectedDialCode + value;
                    return ValidationHelper.validateBasicInternationalPhone(
                      fullNumber,
                      selectedDialCode,
                      value,
                    );
                  },
              decoration: InputDecoration(
                labelText: widget.labelText,
                labelStyle: Styles.style13.copyWith(
                  color: Theme.of(context).hoverColor,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding: widget.contentPadding,
                prefixIcon: widget.showCountryFlag
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: IntrinsicHeight(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap:
                                    widget.enabled ? _showCountryPicker : null,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _buildFlag(selectedCountryCode),
                                      const SizedBox(width: 8),
                                      Text(
                                        selectedDialCode,
                                        style: Styles.style13.copyWith(
                                          color: Theme.of(context).hoverColor,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        color: Theme.of(context).hoverColor,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              VerticalDivider(
                                color: Theme.of(context).dividerColor,
                                thickness: 1,
                                width: 1,
                              ),
                            ],
                          ),
                        ),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                ),
                errorMaxLines: 2,
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                '${countries[selectedCountryCode]?['name']} يتطلب ${_getMinLength() == _getMaxLength() ? '${_getMinLength()} أرقام' : '${_getMinLength()}-${_getMaxLength()} أرقام'}',
                style: Styles.style10.copyWith(
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
