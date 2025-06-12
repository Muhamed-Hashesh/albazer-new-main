import 'package:albazar_app/Features/auth/presentation/views/widgets/custom_button_login.dart';
import 'package:albazar_app/Features/dashboard/approvel%20page/presentation/view/approvel_screen.dart';
import 'package:albazar_app/core/utils/styles.dart';
import 'package:albazar_app/core/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class LoginAdminScreen extends StatelessWidget {
  const LoginAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          // height: 250,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "assets/images/background.jpg",
                ),
                fit: BoxFit.cover),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/logo.png",
                  height: 220,
                ),
              ),
              const CustomTextField(labelText: "اسم المستخدم"),
              const CustomTextField(labelText: "كلمة المرور"),
              GestureDetector(
                onTap: () {},
                child:  Text(
                  "نسيت كلمة المرور؟",
                  style: Styles.style10,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomButtonAuth(
                title: "تسجيل الدخول",
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ApprovelScreen(),));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
