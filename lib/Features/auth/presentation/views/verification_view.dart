import 'package:albazar_app/Features/auth/presentation/cubits/verify_password/verify_password_cubit.dart';
import 'package:albazar_app/core/extensions/navigation_extension.dart';
import 'package:albazar_app/core/helper/messages.dart';
import 'package:albazar_app/core/options/options.dart';
import 'package:albazar_app/core/routes/routes.dart';
import 'package:albazar_app/core/utils/styles.dart';
import 'package:albazar_app/Features/auth/presentation/views/widgets/custom_button_login.dart';
import 'package:albazar_app/core/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerificationView extends StatefulWidget {
  final String email;
  const VerificationView({super.key, required this.email});

  @override
  State<VerificationView> createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
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
                "تأكيد الرمز المرسل",
                style: Styles.style24,
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                width: 262,
                child: Text(
                  'قم بإدخال رمز التفعيل المرسل لبريدك الإلكترونى/ رقم الموبايل لتغير كلمة المرور',
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
                labelText: "رمز التأكيد",
                controller: _codeController,
              ),
              // SizedBox(
              //   height: 30,
              // ),
              BlocListener<VerifyPasswordCubit, VerifyPasswordState>(
                listener: (context, state) {
                  if (state is VerifyPasswordLoading) {
                    AppMessages.showLoading(context);
                  } else {
                    AppMessages.hideLoading(context);
                    if (state is VerifyPasswordSuccess) {
                      context.pushReplacementNamed(AppRoutes.confirmPassword,
                          arguments: widget.email);
                      // context.pushNamed(AppRoutes.cover);
                    }

                    if (state is VerifyPasswordError) {
                      AppMessages.showError(context, state.error);
                    }
                  }
                },
                child: CustomButtonAuth(
                  title: "تأكيد",
                  onPressed: () {
                    if (_codeController.text.isEmpty) {
                      AppMessages.showError(context, "ادخل الرمز المرسل");
                      return;
                    }
                    final options = VerificationOptions(
                      resetCode: _codeController.text,
                    );
                    context.read<VerifyPasswordCubit>().verify(options);
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (_) => const ConfirmPasswordScreen()));
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
