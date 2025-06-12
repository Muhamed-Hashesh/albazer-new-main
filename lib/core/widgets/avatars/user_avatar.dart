import 'dart:io';

import 'package:albazar_app/core/utils/icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserAvatar extends StatelessWidget {
  final String url;
  final double? radius;
  final bool isLoading;
  final File? file;
  const UserAvatar({
    super.key,
    required this.url,
    this.radius,
    this.isLoading = false,
    this.file,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius ?? 30,
      backgroundColor: Colors.grey.shade200,
      foregroundImage: file != null
          ? FileImage(file!)
          : CachedNetworkImageProvider(
              url.trim(),
            ),
      child: isLoading ? null : SvgPicture.asset(AppIcons.profile),
    );
  }
}
