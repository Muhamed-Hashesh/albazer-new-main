import 'package:albazar_app/core/extensions/navigation_extension.dart';
import 'package:albazar_app/core/routes/routes.dart';
import 'package:albazar_app/core/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomAppBarCreateCategory extends StatelessWidget {
  const CustomAppBarCreateCategory({
    super.key,
    this.toHome,
  });
  final bool? toHome;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 124,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
      ),
      child: Stack(
        // mainAxisAlignment: MainAxisAlignment.center,
        alignment: Alignment.center,
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('مرحبا, ماذا تريد أن تعرض اليوم',
                    textAlign: TextAlign.center,
                    style: Styles.style16.copyWith(
                        height: 1.8, color: Theme.of(context).focusColor)),
                Text('أختر الحقل الاكثر تناسبا مع إعلانك',
                    textAlign: TextAlign.center,
                    style: Styles.style12
                        .copyWith(color: Theme.of(context).focusColor)),
              ],
            ),
          ),
          if (context.canPop() || toHome == true)
            Positioned(
              left: 10,
              top: 20,
              child: IconButton(
                  onPressed: () {
                    toHome == true
                        ? context.pushReplacementNamed(AppRoutes.home)
                        : context.pop();
                    // Navigator.of(context).push(MaterialPageRoute(
                    //   builder: (context) => const AddCategoryScreen(),
                    // ));
                  },
                  icon: Icon(
                    FontAwesomeIcons.solidCircleXmark,
                    color: Theme.of(context).hoverColor,
                    size: 28,
                  )),
            )
        ],
      ),
    );
  }
}
