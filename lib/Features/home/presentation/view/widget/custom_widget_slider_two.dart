import 'package:albazar_app/Features/ads/data/models/ad.dart';
import 'package:albazar_app/core/extensions/navigation_extension.dart';
import 'package:albazar_app/core/routes/routes.dart';
import 'package:albazar_app/core/utils/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CustomWidgetSliderTwo extends StatelessWidget {
  final Ad ad;
  const CustomWidgetSliderTwo({
    super.key,
    required this.ad,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(AppRoutes.categoryDetails, arguments: ad);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          width: 105.w,
          // width: MediaQuery.of(context).size.width * 0.325,
          padding: const EdgeInsets.all(8.02),
          decoration: ShapeDecoration(
            color: Theme.of(context).highlightColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    width: 99.w,
                    height: 70.h,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                            ad.images?.first.trim() ?? ''),
                        fit: BoxFit.cover,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(0.0),
                  //   child: Row(
                  //     crossAxisAlignment: CrossAxisAlignment.end,
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     children: [
                  //       ValueListenableBuilder(
                  //           valueListenable: UserHelper.userNotifier,
                  //           builder: (context, user, _) {
                  //             final isFavorite =
                  //                 user?.favorites.contains(ad.id) ?? false;
                  //             return BlocConsumer<FavoriteAdCubit,
                  //                 FavoriteAdState>(
                  //               listener: (context, state) {
                  //                 if (state is FavoriteAdAdded) {
                  //                   AppMessages.showSuccess(
                  //                     context,
                  //                     state.message,
                  //                   );
                  //                 }
                  //                 if (state is FavoriteAdRemoved) {
                  //                   AppMessages.showSuccess(
                  //                     context,
                  //                     state.message,
                  //                   );
                  //                 }
                  //                 if (state is FavoriteAdError) {
                  //                   AppMessages.showError(
                  //                     context,
                  //                     state.error,
                  //                   );
                  //                 }
                  //               },
                  //               builder: (context, state) {
                  //                 return CircleAvatar(
                  //                   backgroundColor: Colors.white,
                  //                   radius: 12,
                  //                   child: GestureDetector(
                  //                     onTap: () {
                  //                       if (state is FavoriteAdLoading) {
                  //                         return;
                  //                       }
                  //                       final cubit =
                  //                           context.read<FavoriteAdCubit>();
                  //                       if (isFavorite) {
                  //                         cubit.removeFromFavorite(id: ad.id!);
                  //                       } else {
                  //                         cubit.addToFavorite(id: ad.id!);
                  //                       }
                  //                     },
                  //                     child: Icon(
                  //                       isFavorite
                  //                           ? Icons.favorite
                  //                           : Icons.favorite_border,
                  //                       color: isFavorite
                  //                           ? Colors.red
                  //                           : const Color(0xff9C9C9C),
                  //                       size: 15,
                  //                     ),
                  //                   ),
                  //                 );
                  //               },
                  //             );
                  //           }),
                  //       const SizedBox(
                  //         width: 5,
                  //       ),
                  //       // ValueListenableBuilder(
                  //       //     valueListenable: UserHelper.userNotifier,
                  //       //     builder: (context, user, _) {
                  //       //       final isFollowing =
                  //       //           user?.following.contains(ad.user) ?? false;
                  //       //       return BlocConsumer<FeaturedAdCubit,
                  //       //           FeaturedAdState>(
                  //       //         listener: (context, state) {
                  //       //           if (state is UserFollowed) {
                  //       //             AppMessages.showSuccess(
                  //       //               context,
                  //       //               state.message,
                  //       //             );
                  //       //           }
                  //       //           if (state is UserUnfollowed) {
                  //       //             AppMessages.showSuccess(
                  //       //               context,
                  //       //               state.message,
                  //       //             );
                  //       //           }
                  //       //           if (state is FeaturedAdError) {
                  //       //             AppMessages.showError(
                  //       //               context,
                  //       //               state.error,
                  //       //             );
                  //       //           }
                  //       //         },
                  //       //         builder: (context, state) {
                  //       //           return CircleAvatar(
                  //       //             backgroundColor: Colors.white,
                  //       //             radius: 12,
                  //       //             child: GestureDetector(
                  //       //               onTap: () {
                  //       //                 if (state is FeaturedAdLoading) {
                  //       //                   return;
                  //       //                 }
                  //       //                 final cubit =
                  //       //                     context.read<FeaturedAdCubit>();
                  //       //                 if (isFollowing) {
                  //       //                   cubit.unfollowUser(id: ad.user!);
                  //       //                 } else {
                  //       //                   cubit.followUser(id: ad.user!);
                  //       //                 }
                  //       //               },
                  //       //               child: Icon(
                  //       //                 isFollowing
                  //       //                     ? Icons.star
                  //       //                     : Icons.star_border,
                  //       //                 color: isFollowing
                  //       //                     ? AppColor.coverPageColor
                  //       //                     : const Color(0xff9C9C9C),
                  //       //                 size: 15,
                  //       //               ),
                  //       //             ),
                  //       //           );
                  //       //         },
                  //       //       );
                  //       //     }),
                  //     ],
                  //   ),
                  // )
                ],
              ),
              Flexible(
                child: Text(
                    'سعر: ${ad.price ?? ad.rentalFees ?? ad.downPayment}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: Styles.style12.copyWith(
                        color: const Color(0xff8C8C8C), fontSize: 14)),
              ),
              SizedBox(height: 4.h),
              Flexible(
                child: Text(ad.adTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: Styles.style502
                        .copyWith(color: const Color(0xff8C8C8C), fontSize: 7)),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.date_range,
                          size: 10,
                          color: Color(0xff8C8C8C),
                        ),
                        Text(
                          DateFormat("yyyy/MM/dd").format(ad.createdAt),
                          style: const TextStyle(
                            color: Color(0xff8C8C8C),
                            fontSize: 5,
                            fontFamily: 'Noor',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Flexible(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 10,
                          color: Color(0xff8C8C8C),
                        ),
                        Flexible(
                          child: Text(
                            ad.propertyLocation ?? '',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              color: Color(0xff8C8C8C),
                              fontSize: 5,
                              fontFamily: 'Noor',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/// .copyWith(color: const Color(0xff8C8C8C))),