import 'package:albazar_app/core/functions/ValidationHelper.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:albazar_app/core/utils/styles.dart';

class CustomPhoneField extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final String initialCountryCode;
  final String? Function(PhoneNumber?)? validator;
  final void Function(PhoneNumber?)? onChanged;
  final void Function(PhoneNumber?)? onSaved;
  final bool readOnly;
  final bool enabled;
  final bool showCountryFlag;
  final TextAlign textAlign;
  final double borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final TextDirection textDirection;

  const CustomPhoneField({
    super.key,
    required this.labelText,
    this.controller,
    this.initialCountryCode = 'EG',
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
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 17),
      child: Directionality(
        textDirection: textDirection,
        child: IntlPhoneField(
          controller: controller,
          initialCountryCode: initialCountryCode,
          keyboardType: TextInputType.phone,
          onChanged: onChanged,
          onSaved: onSaved,
          readOnly: readOnly,
          enabled: enabled,
          textAlign: textAlign,
          flagsButtonPadding: const EdgeInsets.only(right: 8),
          showDropdownIcon: true,
          showCountryFlag: showCountryFlag,
          style: Styles.style13.copyWith(color: Theme.of(context).hoverColor),
          validator: validator ??
              (phone) {
                final completeNumber = phone?.completeNumber;
                return ValidationHelper.validateBasicInternationalPhone(
                  completeNumber,
                  phone?.countryCode,
                  phone?.number,
                );
              },
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle:
                Styles.style13.copyWith(color: Theme.of(context).hoverColor),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding: contentPadding,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            errorMaxLines: 2,
          ),
        ),
      ),
    );
  }
}
