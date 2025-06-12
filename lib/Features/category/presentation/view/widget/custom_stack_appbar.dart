import 'package:albazar_app/Features/ads/data/models/ad.dart';
import 'package:albazar_app/Features/favorite/presentation/cubit/favorite_ad_cubit.dart';
import 'package:albazar_app/core/helper/messages.dart';
import 'package:albazar_app/core/helper/user_helper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomStackAppbar extends StatefulWidget {
  final Ad ad;
  const CustomStackAppbar({super.key, required this.ad});

  @override
  State<CustomStackAppbar> createState() => _CustomStackAppbarState();
}

class _CustomStackAppbarState extends State<CustomStackAppbar> {
  int _currentIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CarouselSlider(
          carouselController: _controller,
          options: CarouselOptions(
            height: 300,
            enlargeCenterPage: true,
            viewportFraction: 1,
            // autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: widget.ad.images?.map((url) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                url.trim(),
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            );
          }).toList(),
        ),
        Positioned(
          top: 15,
          left: 15,
          child: Row(
            children: [
              // ValueListenableBuilder(
              //     valueListenable: UserHelper.userNotifier,
              //     builder: (context, user, _) {
              //       final isFollowing =
              //           user?.following.contains(widget.ad.user) ?? false;
              //       log("IS FOLLOWING: ${user?.following.contains(widget.ad.user)}");
              //       return BlocConsumer<FeaturedAdCubit, FeaturedAdState>(
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
              //           return Container(
              //             decoration: const BoxDecoration(
              //               color: Colors.white,
              //               shape: BoxShape.circle,
              //             ),
              //             child: IconButton(
              //               onPressed: () {
              //                 if (state is FeaturedAdLoading) return;
              //                 final cubit = context.read<FeaturedAdCubit>();
              //                 if (isFollowing) {
              //                   cubit.unfollowUser(id: widget.ad.user!);
              //                 } else {
              //                   cubit.followUser(id: widget.ad.user!);
              //                 }
              //               },
              //               icon: Icon(
              //                   isFollowing ? Icons.star : Icons.star_border,
              //                   color: isFollowing
              //                       ? AppColor.coverPageColor
              //                       : Colors.black),
              //             ),
              //           );
              //         },
              //       );
              //     }),
              // _buildIconButton(Icons.star_border),
              const SizedBox(width: 10),
              ValueListenableBuilder(
                  valueListenable: UserHelper.userNotifier,
                  builder: (context, user, _) {
                    final isFavorite =
                        user?.favorites.contains(widget.ad.id) ?? false;
                    return BlocConsumer<FavoriteAdCubit, FavoriteAdState>(
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
                        return Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {
                              if (state is FavoriteAdLoading) return;
                              final cubit = context.read<FavoriteAdCubit>();
                              if (isFavorite) {
                                cubit.removeFromFavorite(id: widget.ad.id!);
                              } else {
                                cubit.addToFavorite(id: widget.ad.id!);
                              }
                            },
                            iconSize: 30,
                            icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite ? Colors.red : Colors.black),
                            // Icon(
                            //                                   isFavorite
                            //                                       ? Icons.favorite
                            //                                       : Icons.favorite_border,
                            //                                   color: isFavorite
                            //                                       ? Colors.red
                            //                                       : AppColor.coverPageColor,
                            //                                 ),
                          ),
                        );
                      },
                    );
                  }),
              // _buildIconButton(Icons.favorite_border),
            ],
          ),
        ),
        PositionedDirectional(
          start: 10,
          child: IconButton(
              onPressed: () {
                _controller.previousPage();
              },
              icon: const Icon(Icons.arrow_back_ios,
                  color: Colors.white, size: 24)),
        ),
        PositionedDirectional(
          end: 10,
          child: IconButton(
            onPressed: () {
              _controller.nextPage();
            },
            icon: const Icon(Icons.arrow_forward_ios,
                color: Colors.white, size: 24),
          ),
        ),
        Positioned(
          bottom: 15,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.ad.images!.asMap().entries.map((entry) {
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _currentIndex == entry.key ? Colors.white : Colors.grey,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // Widget _buildIconButton(IconData icon) {
  //   return Container(
  //     decoration: const BoxDecoration(
  //       color: Colors.white,
  //       shape: BoxShape.circle,
  //     ),
  //     child: IconButton(
  //       icon: Icon(icon, color: Colors.black),
  //       onPressed: () {},
  //     ),
  //   );
  // }
}
