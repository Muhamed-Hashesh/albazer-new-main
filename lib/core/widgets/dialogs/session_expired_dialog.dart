import 'package:albazar_app/core/extensions/navigation_extension.dart';
import 'package:albazar_app/core/helper/user_helper.dart';
import 'package:albazar_app/core/routes/routes.dart';
import 'package:albazar_app/core/utils/colors.dart';
import 'package:albazar_app/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class SessionExpiredDialog extends StatelessWidget {
  const SessionExpiredDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: const Text("انتهت الجلسة"),
        content: const Text("يرجى تسجيل الدخول مرة أخرى"),
        actions: [
          Center(
            child: CustomButton(
              backgroundColor: Colors.black,
              textStyle: const TextStyle(color: AppColor.coverPageColor),
              title: "تسجيل الدخول",
              onPressed: () async {
                await UserHelper.logout();
                if (!context.mounted) return;
                context.pushNamedAndRemoveUntil(
                  AppRoutes.login,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
