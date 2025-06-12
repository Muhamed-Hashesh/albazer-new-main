import 'package:albazar_app/core/helper/user_helper.dart';
import 'package:albazar_app/core/utils/icons.dart';
import 'package:albazar_app/core/widgets/avatars/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeAppBar extends StatelessWidget {
  final VoidCallback onProfileTap, onMessagesTap;
  const HomeAppBar({
    super.key,
    required this.onProfileTap,
    required this.onMessagesTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
        // boxShadow: [
        //   BoxShadow(
        //     color: Theme.of(context).shadowColor,
        //     blurRadius: 4,
        //     offset: Offset(0, 4),
        //     spreadRadius: 0,
        //   )
        // ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            // Row(
            //   mainAxisSize: MainAxisSize.min,
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ValueListenableBuilder(
                    valueListenable: UserHelper.userNotifier,
                    builder: (context, user, _) {
                      return GestureDetector(
                        onTap: onProfileTap,
                        child: UserAvatar(
                          radius: 16,
                          url: user?.profileImage ?? '',
                        ),
                      );
                    }),
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/logo2.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                GestureDetector(
                    onTap: onMessagesTap,
                    child: SvgPicture.asset(
                      width: 28,
                      height: 28,
                      AppIcons.chatOnline,
                      color: Theme.of(context).focusColor,
                    ))
              ],
            ),
            // const SizedBox(
            //   height: 10,
            // )
          ],
        ),
      ),
    );
  }
}
