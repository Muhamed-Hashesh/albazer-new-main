import 'package:albazar_app/Features/Featured%20Items/presentation/cubit/featured_ad_cubit.dart';
import 'package:albazar_app/Features/ads/data/models/ad.dart';
import 'package:albazar_app/Features/category/data/models/category.dart';
import 'package:albazar_app/Features/favorite/presentation/cubit/favorite_ad_cubit.dart';
import 'package:albazar_app/core/di/locator.dart';
import 'package:albazar_app/core/extensions/navigation_extension.dart';
import 'package:albazar_app/core/helper/messages.dart';
import 'package:albazar_app/core/helper/user_helper.dart';
import 'package:albazar_app/core/routes/routes.dart';
import 'package:albazar_app/core/utils/colors.dart';
import 'package:albazar_app/core/utils/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomCardItem extends StatelessWidget {
  final Ad ad;
  final Category category;
  final void Function()? onTap;
  final bool showStar;

  final ValueChanged<bool>? onFavoriteTap;
  const CustomCardItem({
    super.key,
    required this.ad,
    required this.category,
    this.onFavoriteTap,
    this.onTap,
    this.showStar = true,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => locator<FavoriteAdCubit>(),
        ),
        BlocProvider(
          create: (context) => locator<FeaturedAdCubit>(),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: _CardItem(
          ad: ad,
          category: category,
          showStar: showStar,
          onTap: () {
            context.pushNamed(AppRoutes.categoryDetails, arguments: ad);
          },
        ),
      ),
    );
  }
}

class _CardItem extends StatelessWidget {
  const _CardItem({
    required this.ad,
    required this.category,
    this.onTap,
    required this.showStar,
  });

  final Ad ad;
  final Category category;
  final void Function()? onTap;
  final bool showStar;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).highlightColor,
          borderRadius: BorderRadius.circular(23.73),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.43,
              height: 145.h,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                // image: const DecorationImage(
                //   image: AssetImage("assets/images/image3.png"),
                //   fit: BoxFit.fill,
                // ),
                borderRadius: BorderRadius.circular(10.89),
              ),
              child: CachedNetworkImage(
                imageUrl: ad.images == null || ad.images!.isEmpty
                    ? category.image.trim()
                    : ad.images!.first.trim(),
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => const Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                  size: 32,
                ),
              ),
            ),
            const SizedBox(width: 10),
            // ignore: prefer_const_constructors
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'سعر: ${ad.price ?? ad.rentalFees ?? 'N/A'}',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: Color(0xff8C8C8C),
                            fontSize: 18.15,
                            fontFamily: 'Noor',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ValueListenableBuilder(
                              valueListenable: UserHelper.userNotifier,
                              builder: (context, user, _) {
                                final isFavorite =
                                    user?.favorites.contains(ad.id) ?? false;
                                return BlocConsumer<FavoriteAdCubit,
                                    FavoriteAdState>(
                                  listener: (context, state) {
                                    if (state is FavoriteAdAdded) {
                                      AppMessages.showSuccess(
                                        context,
                                        state.message,
                                      );
                                    }
                                    if (state is FavoriteAdRemoved) {
                                      AppMessages.showSuccess(
                                        context,
                                        state.message,
                                      );
                                    }
                                    if (state is FavoriteAdError) {
                                      AppMessages.showError(
                                        context,
                                        state.error,
                                      );
                                    }
                                  },
                                  builder: (context, state) {
                                    return IconButton(
                                      onPressed: () {
                                        if (state is FavoriteAdLoading) return;
                                        final cubit =
                                            context.read<FavoriteAdCubit>();
                                        if (isFavorite) {
                                          cubit.removeFromFavorite(id: ad.id!);
                                        } else {
                                          cubit.addToFavorite(id: ad.id!);
                                        }
                                      },
                                      icon: Icon(
                                        isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isFavorite
                                            ? Colors.red
                                            : AppColor.coverPageColor,
                                      ),
                                    );
                                  },
                                );
                              }),
                          if (showStar) ...[
                            const SizedBox(width: 5),
                            // ValueListenableBuilder(
                            //     valueListenable: UserHelper.userNotifier,
                            //     builder: (context, user, _) {
                            //       final isFollowing =
                            //           user?.following.contains(ad.user) ??
                            //               false;
                            //       return BlocConsumer<FeaturedAdCubit,
                            //           FeaturedAdState>(
                            //         listener: (context, state) {
                            //           if (state is UserFollowed) {
                            //             AppMessages.showSuccess(
                            //               context,
                            //               state.message,
                            //             );
                            //           }
                            //           if (state is UserUnfollowed) {
                            //             AppMessages.showSuccess(
                            //               context,
                            //               state.message,
                            //             );
                            //           }
                            //           if (state is FeaturedAdError) {
                            //             AppMessages.showError(
                            //               context,
                            //               state.error,
                            //             );
                            //           }
                            //         },
                            //         builder: (context, state) {
                            //           return IconButton(
                            //             onPressed: () {
                            //               if (state is FeaturedAdLoading)
                            //                 return;
                            //               final cubit =
                            //                   context.read<FeaturedAdCubit>();
                            //               if (isFollowing) {
                            //                 cubit.unfollowUser(id: ad.user!);
                            //               } else {
                            //                 cubit.followUser(id: ad.user!);
                            //               }
                            //             },
                            //             icon: Icon(
                            //               isFollowing
                            //                   ? Icons.star
                            //                   : Icons.star_border,
                            //               color: isFollowing
                            //                   ? AppColor.coverPageColor
                            //                   : null,
                            //             ),
                            //           );
                            //         },
                            //       );
                            //     }),
                          ],
                          // const Icon(Icons.star_border),
                        ],
                      )
                    ],
                  ),
                  Text(
                    ad.adTitle,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                        color: Color(0xff8C8C8C),
                        fontSize: 12,
                        fontFamily: 'Noor',
                        fontWeight: FontWeight.w400,
                        overflow: TextOverflow.clip),
                    maxLines: 1,
                  ),
                  Text(
                    ad.description,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Color(0xff8C8C8C),
                      fontSize: 12,
                      fontFamily: 'Noor',
                      fontWeight: FontWeight.w400,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 2,
                  ),
                  // Spacer(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      _serialNumber,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: Color(0xff8C8C8C),
                        fontSize: 7.26,
                        fontFamily: 'Noor',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      if (ad.numberOfRooms != null &&
                          ad.numberOfRooms != 0) ...[
                        const Icon(Icons.bed_outlined,
                            color: Color(0xff8C8C8C)),
                        Flexible(
                          child: Text('${ad.numberOfRooms} غرفة',
                              style: Styles.style7026.copyWith(
                                color: const Color(0xff8C8C8C),
                              )),
                        ),
                        const SizedBox(width: 5),
                      ],
                      if (ad.numberOfBathrooms != null &&
                          ad.numberOfBathrooms != 0) ...[
                        const Icon(Icons.bathtub_outlined,
                            color: Color(0xff8C8C8C)),
                        Flexible(
                          child: Text('${ad.numberOfBathrooms} حمام',
                              style: Styles.style7026
                                  .copyWith(color: const Color(0xff8C8C8C))),
                        ),
                      ]
                    ],
                  ),
                  Row(
                    children: [
                      if (ad.area != null && ad.area! != 0) ...[
                        const Icon(FontAwesomeIcons.ruler,
                            color: Color(0xff8C8C8C)),
                        Flexible(
                          child: Text('${ad.area} sqft',
                              style: Styles.style7026
                                  .copyWith(color: const Color(0xff8C8C8C))),
                        ),
                        const SizedBox(width: 5),
                      ],
                      if (ad.propertyLocation != null &&
                          ad.propertyLocation!.isNotEmpty) ...[
                        const Icon(
                          Icons.location_on_outlined,
                          color: Color(0xff8C8C8C),
                        ),
                        Flexible(
                          child: Text(
                            '${ad.propertyLocation}',
                            style: Styles.style7026.copyWith(
                              color: const Color(0xff8C8C8C),
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 2,
                          ),
                        ),
                      ]
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String get _serialNumber => switch (category.id) {
        '67f02b0fa52c9287a418edbf' => "PR${ad.id}",
        '67f02ae9a52c9287a418edbb' => "PS${ad.id}",
        '67f02b3da52c9287a418edc3' => "BL${ad.id}",
        '67f02b93a52c9287a418ede6' => "CA${ad.id}",
        _ => '',
      };
}
