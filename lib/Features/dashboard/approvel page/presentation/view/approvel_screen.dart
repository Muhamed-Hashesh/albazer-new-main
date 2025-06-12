import 'package:albazar_app/Features/ads/data/models/ad.dart';
import 'package:albazar_app/Features/category/data/models/category.dart';
import 'package:albazar_app/Features/category/presentation/cubits/ads/category_ads_cubit.dart';
import 'package:albazar_app/Features/category/presentation/cubits/categories/categories_cubit.dart';
import 'package:albazar_app/Features/category/presentation/view/category_screen.dart';
import 'package:albazar_app/Features/dashboard/approvel%20details%20page/presentation/cubit/approval_cubit.dart';
import 'package:albazar_app/Features/dashboard/approvel%20details%20page/presentation/view/approvel_details_screen.dart';
import 'package:albazar_app/Features/dashboard/approvel%20page/presentation/widget/custom_widget_card_approvel.dart';
import 'package:albazar_app/core/di/locator.dart';
import 'package:albazar_app/core/enums/request_status.dart';
import 'package:albazar_app/core/options/options.dart';
import 'package:albazar_app/core/options/queries_options.dart';
import 'package:albazar_app/core/widgets/loading/custom_skeleton_widget.dart';
import 'package:albazar_app/core/widgets/loading/lazy_loading_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApprovelScreen extends StatefulWidget {
  const ApprovelScreen({super.key});

  @override
  State<ApprovelScreen> createState() => _ApprovelScreenState();
}

class _ApprovelScreenState extends State<ApprovelScreen> {
  final List<String> tabs = [
    "عقارات للبيع",
    "عقارات للإيجار",
    "أراضي و مباني",
    "سيارات"
  ];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        return DefaultTabController(
          length: state.status == RequestStatus.loading
              ? 4
              : state.categories.length,
          child: Scaffold(
            backgroundColor: Theme.of(context).cardColor,
            body: SafeArea(
              child: Column(
                children: [
                  Card(
                    color: Colors.white,
                    elevation: 2,
                    margin: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                      side: BorderSide.none,
                    ),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).shadowColor,
                            blurRadius: 4,
                            offset: Offset(0, -1),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12),
                      child: SizedBox(
                        height: 40,
                        child: CustomSkeletonWidget(
                          isLoading: state.status == RequestStatus.loading,
                          child: TabBar(
                            indicator: BoxDecoration(
                              color: Theme.of(context).hoverColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            dividerColor: Colors.transparent,
                            // labelColor: Colors.white,
                            isScrollable: true,
                            labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 13,
                              fontFamily: 'Noor',
                              fontWeight: FontWeight.w400,
                            ),
                            unselectedLabelColor: Theme.of(context).focusColor,
                            indicatorSize: TabBarIndicatorSize.tab,
                            tabAlignment: TabAlignment.start,
                            tabs: tabs.map((tab) => Tab(text: tab)).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<CategoriesCubit, CategoriesState>(
                      builder: (context, state) {
                        if (state.status == RequestStatus.loading &&
                            state.categories.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state.status == RequestStatus.error) {
                          return Center(
                            child: Text(
                              state.error,
                            ),
                          );
                        }
                        return TabBarView(
                          children: List.generate(
                            state.categories.length,
                            (index) => BlocProvider(
                              create: (context) => locator<CategoryAdsCubit>()
                                ..refreshCategoryAds(
                                  options: PaginationOptions(
                                    queryOptions: AdsQueryOptions(
                                      category: state.categories[index].id,
                                      pending: true,
                                    ),
                                  ),
                                ),
                              child: PendingAdsTabView(
                                category: state.categories[index],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class PendingAdsTabView extends StatefulWidget {
  final Category category;
  const PendingAdsTabView({super.key, required this.category});

  @override
  State<PendingAdsTabView> createState() => _PendingAdsTabViewState();
}

class _PendingAdsTabViewState extends State<PendingAdsTabView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryAdsCubit, CategoryAdsState>(
      builder: (context, state) {
        return CustomRefreshWidget(
          onRefresh: () => _refresh(context),
          child: LazyLoadingView.list(
            scrollController: _scrollController,

            shrinkWrap: true,
            primary: false,
            onRequest: () async {
              if (state.isLastPage) return;
              context.read<CategoryAdsCubit>().getCategoryAds(
                    options: PaginationOptions(
                      queryOptions: AdsQueryOptions(
                          category: widget.category.id, pending: true),
                    ),
                  );
              // await Future.delayed(const Duration(seconds: 2), () {
              //   _page++;
              //   setState(() {
              //     _isLoading = false;
              //   });
              //   log("request end: $_page");
              // });
            },
            firstPageLoader: CustomSkeletonWidget(
              isLoading: true,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                shrinkWrap: true,
                itemBuilder: (context, index) => _loadingAds[index],
                itemCount: _loadingAds.length,
              ),
            ),
            loader: CustomSkeletonWidget(
              isLoading: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CustomWidgetCardApprovel(
                  ad: _dummyAd,
                  onTap: () {},
                ),
              ),
            ),
            page: state.page,

            // error: 'ssdsd',
            limit: 10,
            isLoading: state.status == RequestStatus.loading,
            isLastPage: state.isLastPage,
            error: state.error,
            items: List.generate(
              state.ads.length,
              (index) => CustomWidgetCardApprovel(
                  ad: state.ads[index],
                  onTap: () async {
                    // (context).pushNamed(AppRoutes.approvelDetails);
                    final update =
                        await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => locator<ApprovalCubit>(),
                                child: ApprovelDetailsScreen(
                                  ad: state.ads[index],
                                ),
                              ),
                            )) ??
                            false;
                    if (!update || !context.mounted) return;
                    _refresh(context);
                  }),
            ),
          ),
        );
      },
    );
  }

  Future<void> _refresh(BuildContext context) async {
    context.read<CategoryAdsCubit>().refreshCategoryAds(
          options: PaginationOptions(
            queryOptions:
                AdsQueryOptions(category: widget.category.id, pending: true),
          ),
        );
  }

  List<Widget> get _loadingAds => List.generate(
        10,
        (_) => CustomWidgetCardApprovel(
          ad: _dummyAd,
        ),
      );

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
}
