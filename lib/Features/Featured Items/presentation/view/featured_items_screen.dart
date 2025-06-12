import 'dart:developer';

import 'package:albazar_app/Features/Featured%20Items/presentation/cubit/featured_ad_cubit.dart';
import 'package:albazar_app/Features/ads/data/models/ad.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/form_header.dart';
import 'package:albazar_app/Features/category/data/models/category.dart';
import 'package:albazar_app/Features/category/presentation/view/widget/custom_category_item.dart';
import 'package:albazar_app/core/helper/user_helper.dart';
import 'package:albazar_app/core/utils/icons.dart';
import 'package:albazar_app/core/widgets/loading/custom_skeleton_widget.dart';
import 'package:albazar_app/core/widgets/loading/lazy_loading_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeaturedItemsScreen extends StatefulWidget {
  const FeaturedItemsScreen({super.key});

  @override
  State<FeaturedItemsScreen> createState() => _FeaturedItemsScreenState();
}

class _FeaturedItemsScreenState extends State<FeaturedItemsScreen> {
  final int _page = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const FormHeader(
              title: "متابعه",
              image: AppIcons.following,
              isIcon: true,
              toHome: true,
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ValueListenableBuilder(
                  valueListenable: UserHelper.userNotifier,
                  builder: (context, user, _) {
                    final following = user?.following ?? [];
                    return BlocBuilder<FeaturedAdCubit, FeaturedAdState>(
                      builder: (context, state) {
                        return LazyLoadingView.list(
                          scrollController: _scrollController,
                          onRequest: () {},
                          firstPageLoader: CustomSkeletonWidget(
                            isLoading: true,
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              itemBuilder: (context, index) =>
                                  _loadingAds[index],
                              itemCount: _loadingAds.length,
                            ),
                          ),
                          loader: CustomSkeletonWidget(
                            isLoading: true,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: CustomCardItem(
                                ad: _dummyAd,
                                category: const Category(
                                    id: 'id', name: 'name', image: 'image'),
                              ),
                            ),
                          ),
                          page: _page,
                          error: state is FeaturedAdError ? state.error : '',
                          limit: 10,
                          isLoading: state is FeaturedAdLoading,
                          isLastPage: true,
                          items: state is FeaturedLoaded
                              ? state.ads.where((ad) {
                                  return following.contains(ad.user);
                                }).map((ad) {
                                  log("ad: $ad");
                                  return CustomCardItem(
                                    key: ValueKey(ad.id),
                                    ad: ad,
                                    category: Category(
                                      id: ad.category,
                                      name: '',
                                      image: '',
                                    ),
                                  );
                                }).toList()
                              : [],
                        );
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  final Ad _dummyAd = Ad(
    id: '',
    adTitle: 'sdsdsd',
    description: 'sdsdsd',
    price: "sdsdsd",
    images: const [],
    category: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  List<Widget> get _loadingAds => List.generate(
        10,
        (_) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: CustomCardItem(
            ad: _dummyAd,
            category: const Category(id: 'id', name: 'name', image: 'image'),
          ),
        ),
      );
}
