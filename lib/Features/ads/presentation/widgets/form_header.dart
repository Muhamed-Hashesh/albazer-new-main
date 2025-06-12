import 'package:albazar_app/core/extensions/navigation_extension.dart';
import 'package:albazar_app/core/routes/routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FormHeader extends StatelessWidget {
  final String title, image;
  final bool isIcon;
  final bool toHome;
  final double? size;
  const FormHeader({
    super.key,
    required this.title,
    required this.image,
    this.isIcon = false,
    this.toHome = false,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 124,
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
        //
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isIcon)
                SvgPicture.asset(
                  image,
                  fit: BoxFit.scaleDown,
                  color: Theme.of(context).focusColor,
                  height: size ?? 32,
                  width: size ?? 32,
                )
              else
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: CachedNetworkImage(
                    imageUrl: image,
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                    width: 30,
                    height: 30,
                  ),
                ),
              const SizedBox(
                width: 5,
              ),
              Flexible(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).focusColor,
                    fontSize: 24,
                    fontFamily: 'Noor',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            ],
          ),
          if (context.canPop() || toHome)
            Positioned(
              left: 10,
              top: 20,
              child: IconButton(
                  onPressed: () {
                    toHome
                        ? context.pushReplacementNamed(AppRoutes.home)
                        : context.pop();
                  },
                  icon: Icon(
                    FontAwesomeIcons.solidCircleXmark,
                    color: Theme.of(context).hoverColor,
                    size: 28,
                  )),
            )
        ],
      ),
    );
  }
}
