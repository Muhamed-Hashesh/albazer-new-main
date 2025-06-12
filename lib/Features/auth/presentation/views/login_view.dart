import 'dart:developer';
import 'package:albazar_app/Features/auth/presentation/cubits/login/login_cubit.dart';
import 'package:albazar_app/Features/auth/presentation/views/widgets/custom_section_confirm.dart';
import 'package:albazar_app/core/extensions/navigation_extension.dart';
import 'package:albazar_app/core/functions/ValidationHelper.dart';
import 'package:albazar_app/core/helper/messages.dart';
import 'package:albazar_app/core/options/options.dart';
import 'package:albazar_app/core/routes/routes.dart';
import 'package:albazar_app/core/utils/styles.dart';
import 'package:albazar_app/Features/auth/presentation/views/widgets/custom_button_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/widgets/custom_textfield.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool? isChecked = false;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late bool isHiddenn = true;
  final List<String> _emailSuggestions = [];
  final String _prefsKey = 'saved_emails';

  @override
  void initState() {
    super.initState();
    _loadSavedEmails();
  }

  // Load saved emails from shared preferences
  Future<void> _loadSavedEmails() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmails = prefs.getStringList(_prefsKey) ?? [];
    setState(() {
      _emailSuggestions.addAll(savedEmails);
    });
  }

  // Save email to shared preferences
  Future<void> _saveEmail(String email) async {
    if (email.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final savedEmails = prefs.getStringList(_prefsKey) ?? [];

    // Avoid duplicates
    if (!savedEmails.contains(email)) {
      savedEmails.add(email);
      await prefs.setStringList(_prefsKey, savedEmails);
      setState(() {
        _emailSuggestions.add(email);
      });
    }
  }

  obscurePassword() {
    setState(() {
      isHiddenn = !isHiddenn;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 43, top: 142, left: 39),
          child: SingleChildScrollView(
            child: Form(
              key: formState,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "تسجيل الدخول",
                    style: Styles.style24
                        .copyWith(color: Theme.of(context).focusColor),
                  ),
                  const SizedBox(height: 24),
                  AutofillGroup(
                    child: Column(
                      children: [
                        // Replace the CustomTextField for email with TypeAheadField
                        TypeAheadField<String>(
                          controller: emailController,
                          builder: (context, controller, focusNode) {
                            return TextField(
                              controller: controller,
                              focusNode: focusNode,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.email],
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 10),
                                labelStyle: Styles.style13.copyWith(
                                    color: Theme.of(context).hoverColor),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                label: const Text(
                                  'البريد الإلكترونى',
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                errorBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                errorMaxLines: 2,
                              ),
                            );
                          },
                          suggestionsCallback: (pattern) {
                            final patternLower = pattern.toLowerCase();
                            return _emailSuggestions
                                .where((email) =>
                                    email.toLowerCase().contains(patternLower))
                                .toList()
                                .reversed // Show most recent first
                                .toList();
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(suggestion),
                            );
                          },
                          onSelected: (suggestion) {
                            emailController.text = suggestion;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          labelText: "كلمة المرور",
                          controller: passwordController,
                          autofillHints: const [AutofillHints.password],
                          validator: ValidationHelper.validatePassword,
                          icon: isHiddenn
                              ? Icons.remove_red_eye
                              : Icons.visibility_off,
                          obscureText: isHiddenn,
                          onPressed: () {
                            obscurePassword();
                          },
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.pushNamed(AppRoutes.forgetPassword);
                    },
                    child: Text(
                      "نسيت كلمة المرور؟",
                      style: Styles.style10
                          .copyWith(color: Theme.of(context).focusColor),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomSectionConfirm(
                    isChecked: isChecked!,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value;
                        log(value.toString());
                      });
                    },
                  ),
                  const SizedBox(height: 50),
                  BlocListener<LoginCubit, LoginState>(
                    listener: (context, state) {
                      if (state is LoginLoading) {
                        AppMessages.showLoading(context);
                      } else {
                        AppMessages.hideLoading(context);
                        if (state is LoginSuccess) {
                          // Save the email when login is successful
                          _saveEmail(emailController.text.trim());
                          AppMessages.showSuccess(context, "تم تسجيل الدخول");
                          TextInput.finishAutofillContext();
                          context.pushNamedAndRemoveUntil(AppRoutes.home);
                        }
                        if (state is LoginError) {
                          AppMessages.showError(context, state.error);
                        }
                      }
                    },
                    child: Center(
                      child: CustomButtonAuth(
                        title: "تسجيل الدخول",
                        onPressed: () async {
                          if (formState.currentState!.validate()) {
                            if (isChecked == true) {
                              final options = LoginOptions(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              );
                              context.read<LoginCubit>().login(options);
                            } else {
                              AppMessages.showError(
                                  context, "يرجى الموافقة على الشروط والاحكام");
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "ليس لديك حساب؟",
                        style: Styles.style14
                            .copyWith(color: Theme.of(context).focusColor),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.pushNamed(AppRoutes.signup);
                        },
                        child: Text("سجل هنا",
                            style: Styles.style14.copyWith(
                                decoration: TextDecoration.underline,
                                color: Theme.of(context).focusColor)),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
