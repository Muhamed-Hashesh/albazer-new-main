import 'package:albazar_app/Features/ads/presentation/widgets/form_header.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/forms/buildings_and_lands_form.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/forms/cars_for_sale_form.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/forms/properties_for_rent_form.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/forms/properties_for_sale_form.dart';
import 'package:albazar_app/Features/category/data/models/category.dart';
import 'package:albazar_app/core/widgets/custom_bottom_nav.dart';
import 'package:flutter/material.dart';

class NewAdScreen extends StatelessWidget {
  final Category category;
  const NewAdScreen({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormHeader(
              title: category.name,
              image: category.image,
              toHome: true,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _forms[_categoryNames.indexOf(category.name)],
            ),
            CustomBottomNav(),
          ],
        ),
      ),
    );
  }

  List<Widget> get _forms => [
        PropertiesForRentForm(
          category: category,
        ),
        PropertiesForSaleForm(
          category: category,
        ),
        BuildingsAndLandsForm(
          category: category,
        ),
        CarsForSaleForm(
          category: category,
        ),
      ];

  List<String> get _categoryNames => const [
        'عقار للإيجار',
        'عقار للبيع',
        'مبانى وأراضى',
        'سيارات',
      ];
}
