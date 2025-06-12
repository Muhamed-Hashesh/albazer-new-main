import 'dart:developer';

import 'package:albazar_app/Features/auth/presentation/views/widgets/custom_button_login.dart';
import 'package:albazar_app/Features/category/data/models/category.dart';
import 'package:albazar_app/Features/category/presentation/view/widget/filters/buildings_and_lands_filters_form.dart';
import 'package:albazar_app/Features/category/presentation/view/widget/filters/cars_for_sale_filters_form.dart';
import 'package:albazar_app/Features/category/presentation/view/widget/filters/properties_for_rent_filters_form.dart';
import 'package:albazar_app/Features/category/presentation/view/widget/filters/properties_for_sale_filters_form.dart';
import 'package:albazar_app/core/extensions/navigation_extension.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomFilterDrawer extends StatefulWidget {
  final Map<String, dynamic>? filters;
  final ValueChanged<Map<String, dynamic>?> onResult;
  final Category category;
  const CustomFilterDrawer({
    super.key,
    required this.category,
    this.filters,
    required this.onResult,
  });

  @override
  State<CustomFilterDrawer> createState() => _CustomFilterDrawerState();
}

class _CustomFilterDrawerState extends State<CustomFilterDrawer> {
  final GlobalKey<PropertiesForRentFiltersFormState> _propertiesForRentKey =
      GlobalKey();
  final GlobalKey<PropertiesForSaleFiltersFormState> _propertiesForSaleKey =
      GlobalKey();
  final GlobalKey<BuildingsAndLandsFiltersFormState> _buildingsAndLandsKey =
      GlobalKey();
  final GlobalKey<CarsForSaleFiltersFormState> _carsForSaleKey = GlobalKey();

  @override
  void initState() {
    log("5555555${widget.filters}");
    super.initState();
  }

  List<Widget> get _forms => [
        PropertiesForRentFiltersForm(
          key: _propertiesForRentKey,
          filters: widget.filters,
        ),
        PropertiesForSaleFiltersForm(
          key: _propertiesForSaleKey,
          filters: widget.filters,
        ),
        BuildingsAndLandsFiltersForm(
          key: _buildingsAndLandsKey,
          filters: widget.filters,
        ),
        CarsForSaleFiltersForm(
          key: _carsForSaleKey,
          filters: widget.filters,
        ),
      ];

  List<String> get _categoryNames => const [
        'عقار للإيجار',
        'عقار للبيع',
        'مبانى وأراضى',
        'سيارات',
      ];

  Map<String, dynamic> _search() {
    if (widget.category.name == _categoryNames[0]) {
      return _propertiesForRentKey.currentState!.search();
    }
    if (widget.category.name == _categoryNames[1]) {
      return _propertiesForSaleKey.currentState!.search();
    }
    if (widget.category.name == _categoryNames[2]) {
      return _buildingsAndLandsKey.currentState!.search();
    }
    if (widget.category.name == _categoryNames[3]) {
      return _carsForSaleKey.currentState!.search();
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    final index = _categoryNames.indexOf(widget.category.name);
    log("$index ${widget.category.name}");
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            width: 320,
            height: 100,
            decoration: BoxDecoration(
              color: Theme.of(context).highlightColor,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor,
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        widget.onResult(null);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'إعادة',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Theme.of(context).focusColor,
                          fontSize: 13,
                          fontFamily: 'Noor',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        "فلتر البحث",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).focusColor,
                          fontSize: 24,
                          fontFamily: 'Noor',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (context.canPop())
                      IconButton(
                        onPressed: () {
                          context.pop();
                        },
                        icon: Icon(
                          FontAwesomeIcons.solidCircleXmark,
                          color: Theme.of(context).hoverColor,
                          size: 35,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          // Make this section scrollable
          Expanded(
            child: _forms[index],
          ),

          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomButtonAuth(
              title: "بحث",
              // colorButton: AppColor.coverPageColor,
              // colorText: Colors.black,
              onPressed: () {
                final result = _search();
                log("$result");
                widget.onResult(result.isEmpty ? null : result);
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
