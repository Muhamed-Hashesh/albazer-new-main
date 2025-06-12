import 'package:albazar_app/core/widgets/fields/custom_labeled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberField extends StatelessWidget {
  final String title, metric;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool isExpanded;
  const NumberField({
    super.key,
    required this.title,
    required this.metric,
    this.controller,
    this.validator,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isExpanded) return Expanded(child: _buildField(context));
    return Row(
      children: [
        Expanded(
          child: _buildField(context),
        ),
        const Spacer(
          flex: 2,
        ),
      ],
    );
  }

  CustomLabeledTextField _buildField(BuildContext context) {
    return CustomLabeledTextField(
      label: title,
      controller: controller,
      keyboardType: TextInputType.number,
      validator: validator,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(7),
      ],
      maxLines: 1,
      suffix: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            metric,
            style: TextStyle(
              color: Theme.of(context).focusColor,
              fontSize: 13,
              fontFamily: 'Noor',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
