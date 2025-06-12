import 'package:albazar_app/Features/category/data/models/category.dart';
import 'package:albazar_app/core/extensions/navigation_extension.dart';
import 'package:albazar_app/core/routes/routes.dart';
import 'package:albazar_app/core/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomCardOfCategory extends StatelessWidget {
  // final String iconName;
  // final String text;
  final Category category;
  final void Function()? onTap;
  const CustomCardOfCategory({
    super.key,
    required this.category,
    // required this.iconName,
    // required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(AppRoutes.newAd, arguments: category);
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.only(bottom: 15),
        // color: Colors.red,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 90,
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.77, vertical: 19.34),
              decoration: BoxDecoration(
                border: Border.all(width: 1.29, color: const Color(0xFFFFED00)),
                borderRadius: BorderRadius.circular(25.79),
                color: AppColor.coverPageColor,
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
            SizedBox(
              width: 114.78,
              child: Text(
                category.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).focusColor,
                  fontSize: 16.77,
                  fontFamily: 'Noor',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
