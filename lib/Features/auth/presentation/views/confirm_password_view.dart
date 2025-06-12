import 'package:albazar_app/Features/auth/presentation/cubits/reset_password/reset_password_cubit.dart';
import 'package:albazar_app/core/extensions/navigation_extension.dart';
import 'package:albazar_app/core/functions/ValidationHelper.dart';
import 'package:albazar_app/core/helper/messages.dart';
import 'package:albazar_app/core/options/options.dart';
import 'package:albazar_app/core/utils/styles.dart';
import 'package:albazar_app/Features/auth/presentation/views/widgets/custom_button_login.dart';
import 'package:albazar_app/core/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfirmPasswordScreen extends StatefulWidget {
  final String email;
  const ConfirmPasswordScreen({super.key, required this.email});

  @override
  State<ConfirmPasswordScreen> createState() => _ConfirmPasswordScreenState();
}

class _ConfirmPasswordScreenState extends State<ConfirmPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 180, right: 20, left: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                "إنشاء كلمة مرور جديدة",
                style: Styles.style24,
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                width: 262,
                child: Text(
                  'قم بإنشاء كلمة مرور جديدة',
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
                labelText: "كلمة مرور",
                obscureText: true,
                controller: _passwordController,
                validator: ValidationHelper.validatePassword,
              ),
              CustomTextField(
                labelText: "تأكيد كلمة مرور",
                obscureText: true,
                controller: _confirmController,
                validator: (value) => ValidationHelper.validateConfirmPassword(
                  value,
                  _passwordController.text.trim(),
                ),
              ),
              // SizedBox(
              //   height: 30,
              // ),
              BlocListener<ResetPasswordCubit, ResetPasswordState>(
                listener: (context, state) {
                  if (state is ResetPasswordLoading) {
                    AppMessages.showLoading(context);
                  } else {
                    AppMessages.hideLoading(context);
                    if (state is ResetPasswordSuccess) {
                      AppMessages.showSuccess(context, "تم تعيين كلمة المرور");
                      context.pop();
                      // context.pushNamed(AppRoutes.cover);
                    }

                    if (state is ResetPasswordError) {
                      AppMessages.showError(context, state.error);
                    }
                  }
                },
                child: CustomButtonAuth(
                  title: "تأكيد",
                  onPressed: () {
                    if (_passwordController.text.isEmpty ||
                        _confirmController.text.isEmpty) {
                      AppMessages.showError(
                          context, "الرجاء ادخال كلمة المرور");
                      return;
                    }
                    if (_passwordController.text != _confirmController.text) {
                      AppMessages.showError(context, "كلمة المرور غير متطابقة");
                      return;
                    }

                    final options = ResetPasswordOptions(
                      email: widget.email,
                      password: _passwordController.text,
                    );
                    context.read<ResetPasswordCubit>().resetPassword(options);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
