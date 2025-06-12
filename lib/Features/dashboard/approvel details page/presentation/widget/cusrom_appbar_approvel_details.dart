import 'package:albazar_app/core/extensions/navigation_extension.dart';
import 'package:albazar_app/core/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomAppBarApprovelDetails extends StatelessWidget
    implements PreferredSizeWidget {
  final void Function()? logoutOnPressed;
  final bool isHome;
  const CustomAppBarApprovelDetails({
    super.key,
    this.logoutOnPressed,
    required this.isHome,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: 85,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Theme.of(context).highlightColor,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor,
                blurRadius: 4,
                offset: const Offset(0, 2),
                spreadRadius: 0,
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.logout,
                      size: 40,
                      color: Theme.of(context).hoverColor,
                    ),
                    onPressed: logoutOnPressed,
                  ),
                  // Spacer(),
                  Container(
                    width: 54,
                    height: 54,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/logo2.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (context.canPop() && isHome == false)
                    GestureDetector(
                        onTap: () => (context).pop(),
                        child: SvgPicture.asset(
                          AppIcons.back,
                          color: Theme.of(context).hoverColor,
                        )),
                  // Spacer()
                ],
              )
            ],
          )),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight * 2.5);
}
