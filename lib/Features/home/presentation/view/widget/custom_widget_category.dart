import 'package:albazar_app/Features/category/data/models/category.dart';
import 'package:albazar_app/core/extensions/navigation_extension.dart';
import 'package:albazar_app/core/routes/routes.dart';
import 'package:albazar_app/core/utils/colors.dart';
import 'package:albazar_app/core/utils/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomWidgetCategory extends StatelessWidget {
  final Category category;

  const CustomWidgetCategory({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          AppRoutes.category,
          arguments: category,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.208,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            // spacing: 3.80,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.22,
                height: 76.97,
                padding: const EdgeInsets.symmetric(
                    horizontal: 13.30, vertical: 14.25),
                decoration: ShapeDecoration(
                  color: AppColor.coverPageColor,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 0.95,
                      color: Theme.of(context).focusColor,
                    ),
                    borderRadius: BorderRadius.circular(19),
                  ),
                ),
                child: CachedNetworkImage(
                  imageUrl: category.image.trim(),
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.contain,
                  errorWidget: (context, url, error) => const Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.23,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    category.name,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Styles.style1199
                        .copyWith(color: Theme.of(context).focusColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
