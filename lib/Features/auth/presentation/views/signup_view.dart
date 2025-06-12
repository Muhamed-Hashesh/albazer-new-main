import 'dart:developer';
import 'dart:io';

import 'package:albazar_app/Features/auth/presentation/cubits/signup/signup_cubit.dart';
import 'package:albazar_app/core/extensions/navigation_extension.dart';
import 'package:albazar_app/core/functions/ValidationHelper.dart';
import 'package:albazar_app/core/helper/messages.dart';
import 'package:albazar_app/core/options/options.dart';
import 'package:albazar_app/core/routes/routes.dart';
import 'package:albazar_app/core/utils/styles.dart';
import 'package:albazar_app/Features/auth/presentation/views/widgets/custom_button_login.dart';
import 'package:albazar_app/core/widgets/custom_circle_avatar.dart';
import 'package:albazar_app/core/widgets/custom_divider.dart';
import 'package:albazar_app/Features/auth/presentation/views/widgets/custom_section_confirm.dart';
import 'package:albazar_app/core/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/widgets/custom_phone_field.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  bool isChecked = false;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  String phoneNumber = "";
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<SignupCubit, SignupState>(
          listener: (context, state) {
            if (state is SignupLoading) {
              AppMessages.showLoading(context);
            } else {
              AppMessages.hideLoading(context);
              if (state is SignupSuccess) {
                AppMessages.showSuccess(context, "تم تسجيل الدخول");
                context.pushNamedAndRemoveUntil(AppRoutes.home);
                log("res: ${state.response}");
                // context.pushNamed(AppRoutes.cover);
              }

              if (state is SignupError) {
                AppMessages.showError(context, state.error);
              }
            }
          },
          builder: (context, state) {
            SignupCubit cubit = SignupCubit.get(context);
            return Padding(
              padding: const EdgeInsets.only(right: 25, top: 50, left: 20),
              child: SingleChildScrollView(
                child: Form(
                  key: formState,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "إنشاء حساب",
                        style: Styles.style24
                            .copyWith(color: Theme.of(context).focusColor),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: CustomTextField(
                            labelText: "الاسم الأول",
                            controller: cubit.firstNameController,
                            validator: ValidationHelper.validateFirstName,
                          )),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                              child: CustomTextField(
                            labelText: "الاسم الأخير",
                            controller: cubit.lastNameController,
                            validator: ValidationHelper.validateLastName,
                          )),
                        ],
                      ),
                      CustomTextField(
                        labelText: "البريد الإلكترونى",
                        controller: cubit.emailController,
                        validator: ValidationHelper.validateEmail,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      // CustomTextField(
                      //   labelText: "رقم الموبايل",
                      //   controller: cubit.phoneController,
                      //   validator: ValidationHelper.validatePhoneNumber,
                      //   keyboardType: TextInputType.phone,
                      // ),
                      CustomPhoneField(
                        labelText: 'رقم موبايل',
                        controller: cubit.phoneController,
                        onChanged: (phone) {
                          phoneNumber = phone!.completeNumber;
                          log('📞 ${phone.completeNumber}');
                        },
                      ),
                      CustomTextField(
                        labelText: "كلمه المرور",
                        controller: cubit.passwordController,
                        validator: ValidationHelper.validatePassword,
                        obscureText: true,
                      ),
                      CustomTextField(
                        labelText: "تأكيد كلمه المرور",
                        controller: cubit.confirmPasswordController,
                        validator: (value) =>
                            ValidationHelper.validateConfirmPassword(
                          value,
                          cubit.passwordController.text.trim(),
                        ),
                        obscureText: true,
                      ),
                      CustomSectionConfirm(
                        isChecked: isChecked,
                        onChanged: (value) {
                          setState(() {
                            isChecked = value;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      CustomButtonAuth(
                        title: "إنشاء حساب",
                        onPressed: () {
                          if (formState.currentState!.validate()) {
                            final options = SignupOptions(
                              firstName: cubit.firstNameController.text.trim(),
                              lastName: cubit.lastNameController.text.trim(),
                              phone: phoneNumber,
                              email: cubit.emailController.text.trim(),
                              password: cubit.passwordController.text.trim(),
                            );
                            context.read<SignupCubit>().signup(options);
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const CustomDivider(),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CustomCircleAvatar(
                              icon: FontAwesomeIcons.facebook),
                          Platform.isAndroid
                              ? Container()
                              : const CustomCircleAvatar(
                                  icon: FontAwesomeIcons.apple),
                          CustomCircleAvatar(
                            icon: FontAwesomeIcons.google,
                            onTap: () {
                              context.read<SignupCubit>().googleSignUp();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
