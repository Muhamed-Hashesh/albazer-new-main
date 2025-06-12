import 'package:albazar_app/Features/auth/data/models/user.dart';
import 'package:albazar_app/core/extensions/navigation_extension.dart';
import 'package:albazar_app/core/routes/routes.dart';
import 'package:albazar_app/core/utils/icons.dart';
import 'package:albazar_app/core/widgets/avatars/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UserDetailsBar extends StatelessWidget {
  final UserModel user;
  final String? rent;
  const UserDetailsBar({
    super.key,
    required this.user,
    this.rent,
  });

  @override
  Widget build(BuildContext context) {
    // log('test car ${user}');
    return Opacity(
      opacity: user.id.isEmpty ? 0.5 : 1,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              context.pushNamed(AppRoutes.userPage, arguments: user);
            },
            child: UserAvatar(
              url: user.profileImage ?? '',
              radius: 20,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            "${user.firstName} ${user.lastName}",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).focusColor,
              fontSize: 16,
              fontFamily: 'Noor',
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          // SvgPicture.asset(
          //   rent == 'rent' ? AppIcons.rent : rent == 'sale'? AppIcons.sale: Container(),
          //   // ignore: deprecated_member_use
          //   color: Theme.of(context).hoverColor,
          //   width: 41,
          //   height: 39,
          // ),
          rent == 'إيجار'
              ? SvgPicture.asset(
                  AppIcons.rent,
                  // ignore: deprecated_member_use
                  color: Theme.of(context).hoverColor,
                  width: 41,
                  height: 39,
                )
              : rent == 'بيع'
                  ? SvgPicture.asset(
                      AppIcons.sale,
                      // ignore: deprecated_member_use
                      color: Theme.of(context).hoverColor,
                      width: 41,
                      height: 39,
                    )
                  : Container(),
          const SizedBox(
            width: 8,
          ),
          GestureDetector(
            onTap: () {
              if (user.id.isEmpty) return;
              context.pushNamed(AppRoutes.chat, arguments: user);
            },
            child: SvgPicture.asset(
              AppIcons.chat,
              // ignore: deprecated_member_use
              color: Theme.of(context).hoverColor,
              width: 41,
              height: 39,
            ),
          )
        ],
      ),
    );
  }
}
