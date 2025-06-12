import 'dart:math';
import 'package:albazar_app/Features/ads/presentation/widgets/custom_appbar_create_category.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/custom_card_of_category.dart';
import 'package:albazar_app/Features/category/data/models/category.dart';
import 'package:albazar_app/Features/category/presentation/cubits/categories/categories_cubit.dart';
import 'package:albazar_app/core/enums/request_status.dart';
import 'package:albazar_app/core/widgets/loading/custom_skeleton_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectCategoryScreen extends StatelessWidget {
  const SelectCategoryScreen({super.key});

  List<Category> get _categoriesLoading => List.generate(
        4,
        (_) => Category(
          id: '',
          name: "name" * (Random().nextInt(4) + 1),
          image: "",
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const CustomAppBarCreateCategory(
              toHome: true,
            ),
            const Spacer(),
            Column(
              children: [
                BlocBuilder<CategoriesCubit, CategoriesState>(
                  builder: (context, state) {
                    final list = state.status == RequestStatus.loading &&
                            state.categories.isEmpty
                        ? _categoriesLoading
                        : state.categories;
                    return CustomSkeletonWidget(
                      isLoading: state.status == RequestStatus.loading &&
                          state.categories.isEmpty,
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return Center(
                              child: CustomCardOfCategory(
                                category: list[index],
                                // iconName: "assets/icons/icon4.svg",
                                // text: "عقارات للإيجار",
                              ),
                            );
                          }),
                    );
                  },
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
