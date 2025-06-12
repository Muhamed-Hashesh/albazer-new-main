import 'dart:developer';

import 'package:albazar_app/Features/ads/data/models/ad.dart';
import 'package:albazar_app/Features/ads/presentation/widgets/form_header.dart';
import 'package:albazar_app/Features/category/data/models/category.dart';
import 'package:albazar_app/Features/category/presentation/view/widget/custom_category_item.dart';
import 'package:albazar_app/Features/favorite/presentation/cubit/favorite_ad_cubit.dart';
import 'package:albazar_app/core/helper/user_helper.dart';
import 'package:albazar_app/core/utils/icons.dart';
import 'package:albazar_app/core/widgets/loading/custom_skeleton_widget.dart';
import 'package:albazar_app/core/widgets/loading/lazy_loading_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final int _page = 1;
  // ignore: unused_field
  final bool _isLoading = false;
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
              title: "المفضلة",
              image: AppIcons.favorite,
              isIcon: true,
              size: 27,
              toHome: true,
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ValueListenableBuilder(
                  valueListenable: UserHelper.userNotifier,
                  builder: (context, user, _) {
                    final favorites = user?.favorites ?? [];
                    return BlocBuilder<FavoriteAdCubit, FavoriteAdState>(
                      builder: (context, state) {
                        if (state is FavoritesLoaded) {
                          log('''FAVsss: ${state.ads.where((ad) => favorites.contains(ad.id)).length}''');
                        }
                        return LazyLoadingView.list(
                          scrollController: _scrollController,
                          onRequest: () {},
                          firstPageLoader: CustomSkeletonWidget(
                            isLoading: true,
                            child: ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                          error: state is FavoriteAdError ? state.error : '',
                          limit: 10,
                          isLoading: state is FavoriteAdLoading,
                          isLastPage: true,
                          items: state is FavoritesLoaded
                              ? state.ads.where((ad) {
                                  log("contain: ${favorites.contains(ad.id)}");
                                  return favorites.contains(ad.id);
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
