import 'package:albazar_app/Features/auth/presentation/cubits/forget_password/forget_password_cubit.dart';
import 'package:albazar_app/core/extensions/navigation_extension.dart';
import 'package:albazar_app/core/functions/ValidationHelper.dart';
import 'package:albazar_app/core/helper/messages.dart';
import 'package:albazar_app/core/options/options.dart';
import 'package:albazar_app/core/routes/routes.dart';
import 'package:albazar_app/core/utils/styles.dart';
import 'package:albazar_app/Features/auth/presentation/views/widgets/custom_button_login.dart';
import 'package:albazar_app/core/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetpasswordView extends StatefulWidget {
  const ForgetpasswordView({super.key});

  @override
  State<ForgetpasswordView> createState() => _ForgetpasswordViewState();
}

class _ForgetpasswordViewState extends State<ForgetpasswordView> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 150, right: 30, left: 30),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "نسيت كلمة المرور ",
                    style: Styles.style24,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    width: 262,
                    child: Text(
                      'أدخل بريدك الإلكترونى المسجل أو اسم المستخدم لمساعدتك فى إعادة تعيين كلمة المرور الخاصة بك.',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Color(0xFF1D1D1B),
                        fontSize: 10,
                        fontFamily: 'Noor',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  CustomTextField(
                    labelText: "البريد الإلكترونى",
                    controller: _emailController,
                    validator: ValidationHelper.validateEmail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  // const CustomDivider(
                  //   text: "أو",
                  // ),
                  // const CustomTextField(
                  //   labelText: "رقم التليفون",
                  //   keyboardType: TextInputType.phone,
                  // ),
                  const SizedBox(
                    height: 45,
                  ),
                  BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
                    listener: (context, state) {
                      if (state is ForgetPasswordLoading) {
                        AppMessages.showLoading(context);
                      } else {
                        AppMessages.hideLoading(context);
                        if (state is ForgetPasswordSuccess) {
                          context.pushReplacementNamed(
                            AppRoutes.verification,
                            arguments: _emailController.text.trim(),
                          );
                        }

                        if (state is ForgetPasswordError) {
                          AppMessages.showError(context, state.error);
                        }
                      }
                    },
                    child: CustomButtonAuth(
                      title: "إرسال",
                      onPressed: () {
                        if (_emailController.text.isEmpty) {
                          AppMessages.showError(
                              context, "ادخل البريد الإلكترونى");
                          return;
                        }
                        if (!_formKey.currentState!.validate()) return;
                        final options = ForgetPasswordOptions(
                          email: _emailController.text.trim(),
                        );
                        context
                            .read<ForgetPasswordCubit>()
                            .forgetPassword(options);
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (_) => const VerificationView()));
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
