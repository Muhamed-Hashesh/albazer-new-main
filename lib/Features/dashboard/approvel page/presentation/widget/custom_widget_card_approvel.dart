import 'package:albazar_app/Features/ads/data/models/ad.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomWidgetCardApprovel extends StatelessWidget {
  final Ad ad;
  final Function()? onTap;
  const CustomWidgetCardApprovel({
    super.key,
    this.onTap,
    required this.ad,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 200,
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          color: Theme.of(context).highlightColor,
          // elevation: 5,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 7.93,
                    runSpacing: 8,
                    children: List.generate(ad.images!.length, (index) {
                      return Container(
                        clipBehavior: Clip.antiAlias,
                        width: 62.124568939208984,
                        height: 44.360286712646484,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(3.67)),
                        ),
                        child: CachedNetworkImage(
                            imageUrl: ad.images![index].trim()),
                      );
                    }),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    ad.adTitle,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Theme.of(context).focusColor,
                      fontSize: 19.19,
                      fontFamily: 'Noor',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 230,
                    child: Text(
                      ad.description,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).focusColor,
                        fontSize: 9.60,
                        fontFamily: 'Noor',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
