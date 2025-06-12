import 'dart:developer';

import 'package:albazar_app/Features/Featured%20Items/presentation/cubit/featured_ad_cubit.dart';
import 'package:albazar_app/Features/ads/data/models/ad.dart';
import 'package:albazar_app/Features/auth/data/models/user.dart';
import 'package:albazar_app/Features/category/presentation/cubits/ad_user/ad_user_cubit.dart';
import 'package:albazar_app/Features/category/presentation/cubits/ads/category_ads_cubit.dart';
import 'package:albazar_app/Features/favorite/presentation/cubit/favorite_ad_cubit.dart';
import 'package:albazar_app/core/di/locator.dart';
import 'package:albazar_app/core/enums/request_status.dart';
import 'package:albazar_app/core/extensions/navigation_extension.dart';
import 'package:albazar_app/core/helper/messages.dart';
import 'package:albazar_app/core/helper/ulr_helper.dart';
import 'package:albazar_app/core/helper/user_helper.dart';
import 'package:albazar_app/core/options/options.dart';
import 'package:albazar_app/core/options/queries_options.dart';
import 'package:albazar_app/core/routes/routes.dart';
import 'package:albazar_app/core/utils/colors.dart';
import 'package:albazar_app/core/widgets/avatars/user_avatar.dart';
import 'package:albazar_app/core/widgets/loading/lazy_loading_list_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UserScreen extends StatefulWidget {
  final UserModel user;
  const UserScreen({super.key, required this.user});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final ScrollController _scrollController = ScrollController();
  late UserModel _user = widget.user;

  openDialPad(String phoneNumber) async {
    Uri url = Uri(scheme: "tel", path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print("Can't opend.");
    }
  }

  Future<void> goLaunchUrl() async {
    if (!await launchUrlString("tel://01050625339")) {
      throw Exception('Could not launch ');
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      BlocProvider.of<AdUserCubit>(context).getUser(id: _user.id);
    });
    log("message: ${_user.toString()}");
    // log("length of adssss: ${ad!.name!.length}");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: SafeArea(
        child: BlocListener<AdUserCubit, AdUserState>(
          listener: (context, state) {
            log("sss$state");
            if (state is AdUserLoading || state is AdUserInitial) {
              AppMessages.showLoading(context);
            } else {
              AppMessages.hideLoading(context);
              if (state is AdUserError) {
                AppMessages.showError(context, state.error);
              }
              if (state is AdUserLoaded) {
                _user = state.user;
              }
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 430,
                height: 290,
                clipBehavior: Clip.antiAlias,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor,
                      blurRadius: 4,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      BlocBuilder<AdUserCubit, AdUserState>(
                        builder: (context, state) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: GestureDetector(
                                  onTap: () => context
                                      .read<AdUserCubit>()
                                      .getUser(id: widget.user.id),
                                  child: UserAvatar(
                                    radius: 40,
                                    url: state is AdUserLoaded
                                        ? state.user.profileImage?.trim() ?? ''
                                        : _user.profileImage?.trim() ?? '',
                                  ),
                                ),
                              ),
                              // Spacer(),
                              Expanded(
                                child: Container(
                                  // color: Colors.amber,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                state is AdUserLoaded
                                                    ? "${state.user.firstName} ${state.user.lastName}"
                                                    : "${_user.firstName} ${_user.lastName}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .hoverColor,
                                                  fontSize: 18,
                                                  fontFamily: 'Noor',
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              Text(
                                                'عضو منذ ${state is AdUserLoaded ? state.user.createdAt.year : _user.createdAt.year}',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .hoverColor,
                                                  fontSize: 13,
                                                  fontFamily: 'Noor',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                            ],
                                          ),
                                          CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Colors.yellow,
                                            child: IconButton(
                                              icon: const Icon(Icons.call,
                                                  size: 35,
                                                  color: Colors.black),
                                              onPressed: () async =>
                                                  await UrlHelper.openPhone(
                                                number: widget.user.phone,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            children: [
                                              Text(
                                                'عدد الإعلانات',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .hoverColor,
                                                  fontSize: 16,
                                                  fontFamily: 'Noor',
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              Text(
                                                "5",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .hoverColor,
                                                  fontSize: 13,
                                                  fontFamily: 'Noor',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 25,
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                'متابعين ',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .hoverColor,
                                                  fontSize: 16,
                                                  fontFamily: 'Noor',
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              Text(
                                                state is AdUserLoaded
                                                    ? state
                                                        .user.followers.length
                                                        .toString()
                                                    : widget
                                                        .user.followers.length
                                                        .toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .hoverColor,
                                                  fontSize: 13,
                                                  fontFamily: 'Noor',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) => locator<FeaturedAdCubit>(),
                          ),
                          // BlocProvider.value(
                          //   value: context.read<AdUserCubit>(),
                          // ),
                        ],
                        child: ContactSection(
                          user: _user,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Icon(FontAwesomeIcons.bullhorn),
                            Text(
                              ' الإعلانات',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).hoverColor,
                                fontSize: 16,
                                fontFamily: 'Noor',
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: BlocBuilder<CategoryAdsCubit, CategoryAdsState>(
                  builder: (context, state) {
                    return LazyLoadingView.grid(
                      crossAxisCount: 2, // 3 columns
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 2,
                      childAspectRatio: 0.8,
                      isLoading: state.status == RequestStatus.loading,
                      items: List.generate(
                          state.ads.length,
                          (index) => MultiBlocProvider(
                                providers: [
                                  BlocProvider(
                                    create: (context) =>
                                        locator<FavoriteAdCubit>(),
                                  ),
                                  // BlocProvider(
                                  //   create: (context) =>
                                  //       locator<FeaturedAdCubit>(),
                                  // ),
                                ],
                                child: PostCard(ad: state.ads[index]),
                              )),
                      scrollController: _scrollController,
                      page: state.page,
                      isLastPage: state.isLastPage,
                      limit: 10,
                      error: state.error,
                      shrinkWrap: true,
                      primary: false,
                      onRequest: () async {
                        if (state.isLastPage) return;
                        context.read<CategoryAdsCubit>().getCategoryAds(
                              options: PaginationOptions(
                                queryOptions: AdsQueryOptions(
                                  user: widget.user.id,
                                ),
                              ),
                            );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContactSection extends StatelessWidget {
  final UserModel user;
  const ContactSection({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
            valueListenable: UserHelper.userNotifier,
            builder: (context, userInfo, _) {
              final isFollowing =
                  userInfo?.following.contains(user.id) ?? false;
              return BlocConsumer<FeaturedAdCubit, FeaturedAdState>(
                listener: (context, state) {
                  log("IS FOLLOWING: $isFollowing");
                  if (state is UserFollowed) {
                    AppMessages.showSuccess(context, state.message);
                    context.read<AdUserCubit>().getUser(id: user.id);
                  }
                  if (state is UserUnfollowed) {
                    AppMessages.showSuccess(context, state.message);
                    context.read<AdUserCubit>().getUser(id: user.id);
                  }
                  if (state is FeaturedAdError) {
                    AppMessages.showError(context, state.error);
                  }
                },
                builder: (context, state) {
                  final s = context.read<AdUserCubit>().state;
                  log("STATE: $s");
                  return CustomCardButton(
                    onTap: () {
                      if (userInfo == null) return;
                      if (state is FeaturedAdLoading) return;
                      if (!isFollowing) {
                        context.read<FeaturedAdCubit>().followUser(id: user.id);
                        return;
                      }
                      context.read<FeaturedAdCubit>().unfollowUser(id: user.id);
                    },
                    text: isFollowing ? "الغاء المتابعة" : "متابعة",
                    icon: isFollowing ? Icons.star : Icons.star_border,
                    iconColor:
                        isFollowing ? AppColor.coverPageColor : Colors.white,
                    color: isFollowing ? Colors.white : null,
                    backgroundColor:
                        isFollowing ? Colors.black : AppColor.coverPageColor,
                  );
                },
              );
            }),
        CustomCardButton(
          onTap: () {
            if (user.id.isEmpty) return;
            context.pushNamed(AppRoutes.chat, arguments: user);
          },
          text: "دردشة",
          icon: Icons.chat,
        ),
        CustomCardButton(
          onTap: () async => await UrlHelper.openWhatsapp(
            number: user.phone,
          ),
          text: "واتساب",
          icon: FontAwesomeIcons.whatsapp,
        ),
      ],
    );
  }
}

class PostCard extends StatelessWidget {
  final Ad ad;
  const PostCard({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(AppRoutes.categoryDetails, arguments: ad),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
          color: Theme.of(context).highlightColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: CachedNetworkImage(
                    imageUrl: ad.images?.first.trim() ?? '',
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'سعر: ${ad.price}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Theme.of(context).hoverColor,
                              fontSize: 12.27,
                              fontFamily: 'Noor',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
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
                                    padding: EdgeInsets.zero,
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
                                      color: isFavorite ? Colors.red : null,
                                    ),
                                  );
                                },
                              );
                            }),
                        // IconButton(
                        //     padding: EdgeInsets.zero,
                        //     onPressed: () {},
                        //     icon: const Icon(
                        //       Icons.favorite_border,
                        //     ))
                      ],
                    ),
                    // SizedBox(height: 4),
                    Text(
                      ad.adTitle,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).hoverColor,
                        fontSize: 9.82,
                        fontFamily: 'Noor',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ad.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Theme.of(context).hoverColor,
                        fontSize: 4.91,
                        fontFamily: 'Noor',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'رقم: PLxxx',
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).hoverColor,
                        fontSize: 4.91,
                        fontFamily: 'Noor',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCardButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color? iconColor, backgroundColor, color;
  final VoidCallback? onTap;
  const CustomCardButton(
      {super.key,
      required this.text,
      required this.icon,
      this.iconColor,
      this.backgroundColor,
      this.onTap,
      this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // width: 93,
        padding: const EdgeInsets.symmetric(horizontal: 12.64, vertical: 8.43),
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: ShapeDecoration(
          color: backgroundColor ?? const Color(0xFFFFED00),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.11),
          ),
          shadows: [
            BoxShadow(
              color: Theme.of(context).shadowColor,
              blurRadius: 3.37,
              offset: const Offset(-1.69, 3.37),
              spreadRadius: 0,
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor ?? Colors.white),
            const SizedBox(
              width: 5,
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color ?? Colors.black,
                fontSize: 12,
                fontFamily: 'Noor',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
