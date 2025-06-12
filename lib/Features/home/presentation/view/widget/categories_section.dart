import 'dart:math' hide log;

import 'package:albazar_app/Features/category/data/models/category.dart';
import 'package:albazar_app/Features/category/presentation/cubits/categories/categories_cubit.dart';
import 'package:albazar_app/Features/home/presentation/view/widget/custom_widget_category.dart';
import 'package:albazar_app/core/enums/request_status.dart';
import 'package:albazar_app/core/helper/messages.dart';
import 'package:albazar_app/core/widgets/loading/custom_skeleton_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({
    super.key,
  });

  List<Category> get _categoriesLoading => List.generate(
        10,
        (_) => Category(
          id: '',
          name: "name" * (Random().nextInt(4) + 1),
          image: "",
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoriesCubit, CategoriesState>(
      listener: (context, state) {
        if (state.status == RequestStatus.error &&
            state.categories.isNotEmpty) {
          AppMessages.showError(context, state.error);
        }
      },
      builder: (context, state) {
        return BlocBuilder<CategoriesCubit, CategoriesState>(
          builder: (context, state) {
            final list = state.status == RequestStatus.loading &&
                    state.categories.isEmpty
                ? _categoriesLoading
                : state.categories;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .93,
                height: MediaQuery.of(context).size.height * .15,
                child: CustomSkeletonWidget(
                  isLoading: state.status == RequestStatus.loading,
                  child: state.status == RequestStatus.error &&
                          state.categories.isEmpty
                      ? Center(
                          child: Text(state.error),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            // log("category$index: ${list[index].toJson()}");
                            return CustomWidgetCategory(
                              category: list[index],
                              // children: const [
                              //   CustomWidgetCategory(
                              //       imageName: "assets/icons/icon4.svg", text: "عقارات للإيجار"),
                              //   CustomWidgetCategory(
                              //       imageName: "assets/icons/icon3.svg", text: "عقارات للبيع"),
                              //   CustomWidgetCategory(
                              //       imageName: "assets/icons/icon2.svg", text: "مباني وأراضي"),
                              //   CustomWidgetCategory(
                              //       imageName: "assets/icons/car.svg", text: 'سيارات'),
                              // ],
                            );
                          },
                        ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
