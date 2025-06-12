import 'package:albazar_app/core/utils/styles.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String? selectedValue;
  final String? label;
  final String? hint;
  final List<String>? options;
  final List<CarModel>? carOptions;
  final bool? fill;
  final bool? enable;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String>? validator;

  const CustomDropdown({
    super.key,
    required this.selectedValue,
    this.label,
    this.hint,
    this.options,
    required this.onChanged,
    this.fill,
    this.enable,
    this.validator,
    this.carOptions,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      onChanged: enable == false ? null : onChanged,
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'You must enter a $label';
            }
            return null;
          },
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelText: label,
        hintStyle: Styles.style13.copyWith(
          color: const Color(0xff8C8C8C),
        ),
        hintText: hint,
        labelStyle: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: Theme.of(context).hoverColor),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        filled: fill ?? true,
        fillColor: fill == null
            ? Theme.of(context).highlightColor
            : Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).highlightColor,
            width: 1.3,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).highlightColor,
            width: 1.3,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).highlightColor,
            width: 1.3,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        errorStyle: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: Theme.of(context).focusColor),
      ),
      iconDisabledColor: Theme.of(context).focusColor,
      iconEnabledColor: Theme.of(context).focusColor,
      dropdownColor: Theme.of(context).highlightColor,
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(color: Theme.of(context).hoverColor),
      items: carOptions != null
          ? carOptions?.map((item) {
              return DropdownMenuItem<String>(
                value: item.name,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.image.isNotEmpty)
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: Image.asset(
                          item.image,
                          width: 60,
                          height: 60,
                          // fit: BoxFit.cover,
                          // errorBuilder: (context, error, stackTrace) {
                          // log('stackTrace: $stackTrace');
                          // return Icon(Icons.error);
                          // },
                        ),
                      ),
                    if (item.image.isNotEmpty) const SizedBox(width: 10),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Text(
                        item.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              );
            }).toList()
          : options?.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(
                  option,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            }).toList(),
    );
  }
}

class CarModel {
  final String name;
  final String image;

  CarModel({required this.name, required this.image});
}
