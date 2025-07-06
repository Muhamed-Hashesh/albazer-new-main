import 'package:albazar_app/Features/Featured%20Items/presentation/cubit/featured_ad_cubit.dart';
import 'package:albazar_app/Features/ads/data/models/ad.dart';
import 'package:albazar_app/Features/category/data/models/category.dart';
import 'package:albazar_app/Features/category/presentation/cubits/ads/category_ads_cubit.dart';
import 'package:albazar_app/Features/category/presentation/cubits/categories/categories_cubit.dart';
import 'package:albazar_app/Features/category/presentation/view/category_screen.dart';
import 'package:albazar_app/Features/favorite/presentation/cubit/favorite_ad_cubit.dart';
import 'package:albazar_app/Features/home/presentation/view/widget/categories_section.dart';
import 'package:albazar_app/Features/home/presentation/view/widget/custom_widget_slider_two.dart';
import 'package:albazar_app/Features/home/presentation/view/widget/home_app_bar.dart';
import 'package:albazar_app/core/di/locator.dart';
import 'package:albazar_app/core/enums/request_status.dart';
import 'package:albazar_app/core/extensions/navigation_extension.dart';
import 'package:albazar_app/core/options/options.dart';
import 'package:albazar_app/core/options/queries_options.dart';
import 'package:albazar_app/core/routes/routes.dart';
import 'package:albazar_app/core/utils/styles.dart';
import 'package:albazar_app/core/widgets/loading/custom_skeleton_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onProfileTap, onMessagesTap;
  const HomeScreen(
      {super.key, required this.onProfileTap, required this.onMessagesTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      body: SafeArea(
        child: Stack(
          children: [
            HomeAppBar(
              onProfileTap: widget.onProfileTap,
              onMessagesTap: widget.onMessagesTap,
            ),
            // const SizedBox(
            //   height: 15,
            // ),
            Padding(
              padding: EdgeInsets.only(top: 130.h),
              child: const CategoriesSection(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 255.h),
              child: CustomRefreshWidget(
                onRefresh: () async {
                  // for (int i = 0; i < state.categories.length; i++) {
                  //   locator<CategoryAdsCubit>().getCategoryAds(
                  //       options: PaginationOptions(
                  //     limit: 5,
                  //     queryOptions: AdsQueryOptions(
                  //         sortBy: "-createdAt",
                  //         category: state.categories[i].id,
                  //         post: true),
                  //   ));
                  // }
                  context.pushNamedAndRemoveUntil(AppRoutes.home);
                },
                child: BlocBuilder<CategoriesCubit, CategoriesState>(
                  builder: (context, state) {
                    if (state.status == RequestStatus.loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state.status == RequestStatus.error) {
                      return Center(
                        child: Text(state.error),
                      );
                    }
                    if (state.categories.isEmpty) {
                      return const Center(
                        child: Text("لا توجد بيانات"),
                      );
                    }
                    if (state.categories.isNotEmpty) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: state.categories.length,
                        itemBuilder: (context, index) {
                          return BlocProvider(
                            create: (context) => locator<CategoryAdsCubit>()
                              ..getCategoryAds(
                                options: PaginationOptions(
                                  limit: 5,
                                  queryOptions: AdsQueryOptions(
                                      sortBy: "-createdAt",
                                      category: state.categories[index].id),
                                ),
                              ),
                            child: LatestAdsSection(
                              category: state.categories[index],
                            ),
                          );
                        },
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LatestAdsSection extends StatelessWidget {
  final Category category;
  const LatestAdsSection({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryAdsCubit, CategoryAdsState>(
      builder: (context, state) {
        if (state.status == RequestStatus.success && state.ads.isEmpty) {
          return const SizedBox.shrink();
        }
        return CustomSkeletonWidget(
          isLoading: state.status == RequestStatus.loading,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: state.status == RequestStatus.error
                ? Center(child: Text(state.error))
                : state.status == RequestStatus.loading
                    ? _loading
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "أضيف حديثَا في ${category.name}",
                            style: Styles.style18
                                .copyWith(color: Theme.of(context).focusColor),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          CarouselSlider(
                            items: state.ads.map(
                              (ad) {
                                return MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      create: (context) =>
                                          locator<FavoriteAdCubit>(),
                                    ),
                                    BlocProvider(
                                      create: (context) =>
                                          locator<FeaturedAdCubit>(),
                                    ),
                                  ],
                                  child: CustomWidgetSliderTwo(
                                    ad: ad,
                                  ),
                                );
                              },
                            ).toList(),
                            options: CarouselOptions(
                              padEnds: false,
                              height: 150.h,
                              viewportFraction: .35,
                              enableInfiniteScroll: false,
                            ),
                          ),
                        ],
                      ),
          ),
        );
      },
    );
  }

  Widget get _loading => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "أضيف حديثَا في ${category.name}",
            style: Styles.style18,
          ),
          MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => locator<FavoriteAdCubit>(),
              ),
              BlocProvider(
                create: (context) => locator<FeaturedAdCubit>(),
              ),
            ],
            child: CarouselSlider(
              items: [1, 2, 3, 4, 5, 6].map(
                (e) {
                  return CustomWidgetSliderTwo(
                    ad: Ad.fromJson(const {}),
                  );
                },
              ).toList(),
              options: CarouselOptions(
                padEnds: false,
                height: 150,
                viewportFraction: .35,
                enableInfiniteScroll: false,
              ),
            ),
          ),
        ],
      );
}
