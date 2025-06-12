import 'package:albazar_app/core/extensions/navigation_extension.dart';
import 'package:albazar_app/core/routes/routes.dart';
import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () {
              context.pushNamed(AppRoutes.home, arguments: 0);
            },
            icon: Icon(
              Icons.home_outlined,
              size: 35,
              color: Theme.of(context).hoverColor,
            ),
          ),
          IconButton(
            onPressed: () {
              context.pushNamed(AppRoutes.home, arguments: 1);
            },
            icon: Icon(
              Icons.favorite_border,
              size: 35,
              color: Theme.of(context).hoverColor,
            ),
          ),
          IconButton(
            onPressed: () {
              context.pushNamed(AppRoutes.home, arguments: 2);
            },
            icon: Icon(
              Icons.add_box_outlined,
              size: 35,
              color: Theme.of(context).hoverColor,
            ),
          ),
          IconButton(
            onPressed: () {
              context.pushNamed(AppRoutes.home, arguments: 3);
            },
            icon: Icon(
              Icons.star_border_outlined,
              size: 35,
              color: Theme.of(context).hoverColor,
            ),
          ),
          IconButton(
            onPressed: () {
              context.pushNamed(AppRoutes.home, arguments: 4);
            },
            icon: Icon(
              Icons.person_outline_outlined,
              size: 35,
              color: Theme.of(context).hoverColor,
            ),
          ),
        ],
      ),
    );
  }
}
