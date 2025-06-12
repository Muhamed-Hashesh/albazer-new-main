import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomImageView extends StatelessWidget {
  final List<String> images;
  const CustomImageView({
    super.key,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 7.93,
      runSpacing: 8,
      children: List.generate(images.length, (index) {
        return Container(
          clipBehavior: Clip.antiAlias,
          width: 68.58515930175781,
          height: 48.9734992980957,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4.05)),
          ),
          child: CachedNetworkImage(imageUrl: images[index].trim()),
        );
      }),
    );
  }
}
