import 'package:albazar_app/Features/auth/data/models/user.dart';
import 'package:albazar_app/core/widgets/avatars/user_avatar.dart';
import 'package:flutter/material.dart';

class CustomCardUsers extends StatelessWidget {
  final UserModel user;
  final Function()? onTap;
  const CustomCardUsers({
    super.key,
    this.onTap,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 381,
        padding: const EdgeInsets.all(10),
        decoration: ShapeDecoration(
          // color: const Color(0xFFF6F9FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Card(
          color: Theme.of(context).highlightColor,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                UserAvatar(url: user.profileImage ?? ''),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        "${user.firstName} ${user.lastName}",
                        // textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                          color: Theme.of(context).focusColor,
                          fontSize: 16,
                          fontFamily: 'Noor',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      'مشترك منذ ${user.createdAt.year}',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Theme.of(context).focusColor,
                        fontSize: 10,
                        fontFamily: 'Noor',
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
                const Spacer(),
                Text(
                  'عرض الملف',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: Theme.of(context).focusColor,
                      fontSize: 10,
                      fontFamily: 'Noor',
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.underline),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
