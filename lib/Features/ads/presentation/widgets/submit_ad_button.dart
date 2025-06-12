import 'package:albazar_app/Features/ads/presentation/cubit/new_ad_cubit.dart';
import 'package:albazar_app/Features/auth/presentation/views/widgets/custom_button_login.dart';
import 'package:albazar_app/core/extensions/navigation_extension.dart';
import 'package:albazar_app/core/helper/messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubmitAdButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const SubmitAdButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<NewAdCubit, NewAdState>(
      listener: (context, state) {
        if (state is NewAdLoading) {
          AppMessages.showLoading(context);
        } else {
          AppMessages.hideLoading(context);

          if (state is NewAdError) {
            AppMessages.showError(context, state.error);
          } else if (state is NewAdSubmitted) {
            AppMessages.showSuccess(context, state.message);
            context.pop();
          }
        }
      },
      child: Center(
        child: CustomButtonAuth(
          title: "أنشر الاعلان",
          onPressed: onPressed ?? () {},
        ),
      ),
    );
  }
}
