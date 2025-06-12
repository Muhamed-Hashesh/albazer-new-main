import 'package:albazar_app/core/extensions/navigation_extension.dart';
import 'package:albazar_app/core/routes/routes.dart';
import 'package:albazar_app/core/utils/styles.dart';
import 'package:flutter/material.dart';

class CoverView extends StatelessWidget {
  const CoverView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColor.coverPageColor,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                "assets/images/background.jpg",
              ),
              fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            // Center(
            //   child: Container(
            //     margin: const EdgeInsets.only(top: 132),
            //     width: 195,
            //     height: 195,
            //     decoration: const BoxDecoration(
            //       image: DecorationImage(
            //         image: AssetImage("assets/images/logo2.png"),
            //         fit: BoxFit.fill,
            //       ),
            //     ),
            //   ),
            // ),
            const Spacer(),
            Center(
              child: Image.asset('assets/images/logo.png',
              width: 195,
              height: 195,
              fit: BoxFit.cover,
              ),
            ),
            const Spacer(),

            // const SizedBox(
            //   height: 120,
            // ),
            // CustomButton(
            //   textStyle: Styles.style20.copyWith(color: Colors.black),
            //   backgroundColor: Colors.white,
            //   title: "تسجيل الدخول",
            //   onPressed: () {
            //     context.pushReplacementNamed(AppRoutes.login);
            //   },
            // ),
            MaterialButton(
              minWidth: 185,
              height: 54,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              onPressed: () {
                context.pushReplacementNamed(AppRoutes.login);
              },
              child: Text(
                "تسجيل الدخول",
                style: Styles.style18
                    .copyWith(color: Colors.black, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            // CustomButton(
            //   backgroundColor: AppColor.coverPageColor,
            //   textStyle: Styles.style20.copyWith(
            //     color: Colors.black,
            //   ),
            //   title: 'إنشاء حساب',
            //   onPressed: () {
            //
            //   },
            // ),
            MaterialButton(
              minWidth: 185,
              height: 54,
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              onPressed: () {
                context.pushReplacementNamed(AppRoutes.signup);
              },
              child: Text(
                "إنشاء حساب",
                style: Styles.style20
                    .copyWith(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 125,),
          ],
        ),
      ),
    );
  }
}
