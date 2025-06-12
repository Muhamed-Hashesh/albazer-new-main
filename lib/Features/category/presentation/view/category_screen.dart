// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:albazar_app/Features/ads/data/models/ad.dart';
import 'package:albazar_app/Features/category/data/models/category.dart';
import 'package:albazar_app/Features/category/presentation/cubits/ads/category_ads_cubit.dart';
import 'package:albazar_app/Features/category/presentation/view/widget/custom_category_item.dart';
import 'package:albazar_app/Features/category/presentation/view/widget/custom_filter_drawer.dart';
import 'package:albazar_app/Features/category/presentation/view/widget/pagination_widget.dart';
import 'package:albazar_app/core/enums/request_status.dart';
import 'package:albazar_app/core/extensions/navigation_extension.dart';
import 'package:albazar_app/core/helper/debounce_helper.dart';
import 'package:albazar_app/core/options/options.dart';
import 'package:albazar_app/core/options/queries_options.dart';
import 'package:albazar_app/core/routes/routes.dart';
import 'package:albazar_app/core/utils/colors.dart';
import 'package:albazar_app/core/utils/icons.dart';
import 'package:albazar_app/core/utils/styles.dart';
import 'package:albazar_app/core/widgets/custom_bottom_nav.dart';
import 'package:albazar_app/core/widgets/loading/custom_skeleton_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryScreen extends StatefulWidget {
  final Category category;
  // final String title;
  const CategoryScreen({
    super.key,
    required this.category,
    // required this.title,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic>? _filters;

  String _query = "";

  final DebounceHelper _debounce = DebounceHelper();

  @override
  void initState() {
    super.initState();
    // تحميل البيانات الأولي عند فتح الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // إعادة تعيين الحالة أولاً لضمان البداية بحالة نظيفة
      context.read<CategoryAdsCubit>().resetState();
      context.read<CategoryAdsCubit>().refreshCategoryAds(
            options: PaginationOptions(
              limit: 5,
              queryOptions: AdsQueryOptions(
                category: widget.category.id,
                sortBy: "-createdAt",
              ),
            ),
          );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomFilterDrawer(
        category: widget.category,
        filters: _filters,
        onResult: (filters) {
          if (filters == _filters) return;
          setState(() {
            _filters = filters;
            log("🎯 Applied filters: $_filters");
            print("🎯 Filters length: ${_filters?.length ?? 0}");
            context.read<CategoryAdsCubit>().refreshCategoryAds(
                  options: PaginationOptions(
                    limit: 5,
                    queryOptions: AdsQueryOptions(
                        category: widget.category.id,
                        sortBy: "-createdAt",
                        others: _filters),
                  ),
                );
          });
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 50, left: 15, right: 15),
              width: double.infinity,
              height: 210,
              decoration: BoxDecoration(
                color: Theme.of(context).highlightColor,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      controller: _searchController,
                      onChanged: (value) {
                        if (value.isEmpty) {
                          _debounce.cancel();
                          _query = "";
                          context.read<CategoryAdsCubit>().resetState();
                          context.read<CategoryAdsCubit>().refreshCategoryAds(
                                options: PaginationOptions(
                                  limit: 5,
                                  queryOptions: AdsQueryOptions(
                                    category: widget.category.id,
                                    sortBy: "-createdAt",
                                    others: _filters,
                                  ),
                                ),
                              );
                          setState(() {});
                          return;
                        }
                        _debounce.debounce(callback: () {
                          log("query: $value");
                          _query = value.trim();
                          context.read<CategoryAdsCubit>().resetState();
                          context.read<CategoryAdsCubit>().refreshCategoryAds(
                                options: PaginationOptions(
                                  limit: 5,
                                  queryOptions: AdsQueryOptions(
                                      category: widget.category.id,
                                      query: _query,
                                      sortBy: "-createdAt",
                                      others: _filters),
                                ),
                              );
                          setState(() {});
                        });
                      },
                      onTapOutside: (_) => FocusScope.of(context).unfocus(),
                      decoration: InputDecoration(
                        hintText: 'ابحث عن ${widget.category.name}',
                        fillColor: Theme.of(context).secondaryHeaderColor,
                        filled: true,
                        suffixIcon: Icon(
                          Icons.search,
                          color: Theme.of(context).hoverColor,
                          size: 25,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Theme.of(context).secondaryHeaderColor,
                              width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Theme.of(context).secondaryHeaderColor,
                              width: 1.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _scaffoldKey.currentState!.openDrawer(),
                        child: Container(
                          width: 35,
                          height: 35,
                          margin: const EdgeInsets.only(right: 10),
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(),
                          child: SvgPicture.asset(
                            AppIcons.filter,
                            // ignore: deprecated_member_use
                            color: Theme.of(context).focusColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text("فلتر",
                          style: Styles.style13
                              .copyWith(color: Theme.of(context).focusColor)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          (context).pushReplacementNamed(
                            AppRoutes.category,
                            arguments: widget.category,
                          );
                        },
                        child: Text(
                          'إعادة',
                          style: Styles.style13
                              .copyWith(color: Theme.of(context).focusColor),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Pagination info
            BlocBuilder<CategoryAdsCubit, CategoryAdsState>(
              builder: (context, state) {
                // Add detailed logging for debugging pagination
                log("Pagination Debug - TotalResults: ${state.totalResults}, TotalPages: ${state.totalPages}, CurrentPage: ${state.page}, AdsCount: ${state.ads.length}");

                if (state.totalResults > 0 && state.ads.isNotEmpty) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(
                      'عرض ${state.ads.length} من ${state.totalResults} نتيجة (صفحة ${state.page} من ${state.totalPages})',
                      style: Styles.style13.copyWith(
                        color: Theme.of(context).focusColor.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            // Main content area
            Expanded(
              child: BlocBuilder<CategoryAdsCubit, CategoryAdsState>(
                builder: (context, state) {
                  // Add debug log
                  log("CategoryAdsState: status=${state.status}, ads count=${state.ads.length}, error=${state.error}, page=${state.page}");

                  if ((state.status == RequestStatus.loading ||
                          state.status == RequestStatus.initial) &&
                      state.ads.isEmpty) {
                    return CustomSkeletonWidget(
                      isLoading: true,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => _loadingAds[index],
                        itemCount: _loadingAds.length,
                      ),
                    );
                  }

                  if (state.status == RequestStatus.error) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.error,
                            style: Styles.style16.copyWith(
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<CategoryAdsCubit>().resetState();
                              context
                                  .read<CategoryAdsCubit>()
                                  .refreshCategoryAds(
                                    options: PaginationOptions(
                                      limit: 5,
                                      queryOptions: AdsQueryOptions(
                                        category: widget.category.id,
                                        query: _query,
                                        others: _filters,
                                        sortBy: "-createdAt",
                                      ),
                                    ),
                                  );
                            },
                            child: const Text('إعادة المحاولة'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state.ads.isEmpty &&
                      state.status == RequestStatus.success) {
                    return Center(
                      child: Text(
                        'لا توجد نتائج',
                        style: Styles.style16.copyWith(
                          color: Theme.of(context).focusColor,
                        ),
                      ),
                    );
                  }

                  return CustomRefreshWidget(
                    onRefresh: () async {
                      context.read<CategoryAdsCubit>().resetState();
                      context.read<CategoryAdsCubit>().refreshCategoryAds(
                            options: PaginationOptions(
                              limit: 5,
                              queryOptions: AdsQueryOptions(
                                category: widget.category.id,
                                query: _query,
                                others: _filters,
                                sortBy: "-createdAt",
                              ),
                            ),
                          );
                    },
                    child: Stack(
                      children: [
                        ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                            bottom: 100, // Space for pagination
                          ),
                          itemCount: state.ads.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: CustomCardItem(
                                showStar: false,
                                ad: state.ads[index],
                                category: widget.category,
                              ),
                            );
                          },
                        ),
                        // Loading overlay
                        if (state.status == RequestStatus.loading)
                          Container(
                            color: Colors.black26,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Pagination
            BlocBuilder<CategoryAdsCubit, CategoryAdsState>(
              builder: (context, state) {
                // Show pagination if there are multiple pages, regardless of current ads
                if (state.totalPages <= 1) {
                  return const SizedBox.shrink();
                }
                return PaginationWidget(
                  currentPage: state.page, // Use the current page directly
                  totalPages: state.totalPages,
                  isLoading: state.status == RequestStatus.loading,
                  onPageChanged: (pageNumber) {
                    // Safety check before animating scroll
                    if (_scrollController.hasClients) {
                      _scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                    context.read<CategoryAdsCubit>().goToPage(
                          pageNumber: pageNumber,
                          options: PaginationOptions(
                            limit: 5,
                            queryOptions: AdsQueryOptions(
                              category: widget.category.id,
                              query: _query,
                              others: _filters,
                              sortBy: "-createdAt",
                            ),
                          ),
                        );
                  },
                );
              },
            ),
            // Bottom navigation
            const CustomBottomNav(),
          ],
        ),
      ),
    );
  }

  List<Widget> get _loadingAds => List.generate(
        5, // Changed to 5 to match page size
        (_) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: CustomCardItem(
            showStar: false,
            ad: _dummyAd,
            category: widget.category,
          ),
        ),
      );

  final Ad _dummyAd = Ad(
    id: '',
    currency: '',
    adTitle: 'sdsdsd',
    description: 'sdsdsd',
    price: "sdsdsd",
    images: const [],
    category: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  // ignore: unused_element
  void _restFilters() {
    if (_searchController.text.isEmpty) return;
    _searchController.clear();
    _query = "";

    context.read<CategoryAdsCubit>().resetState();
    context.read<CategoryAdsCubit>().refreshCategoryAds(
          options: PaginationOptions(
            limit: 5,
            queryOptions: AdsQueryOptions(
              category: widget.category.id,
              others: _filters,
              sortBy: "-createdAt",
            ),
          ),
        );
  }
}

class CustomCardFilter extends StatelessWidget {
  final String text;
  const CustomCardFilter({
    super.key,
    this.text = "sqft",
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 110,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: ShapeDecoration(
            color: const Color(0xFFF6F9FF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '0',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: 'Simplified Arabic',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: 'Simplified Arabic',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class CustomRefreshWidget extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const CustomRefreshWidget({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CustomScrollView(
        // physics: const BouncingScrollPhysics(),
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: onRefresh,
          ),
          SliverToBoxAdapter(
            child: child,
          )
        ],
      );
    }
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColor.coverPageColor,
      backgroundColor: Colors.black,
      child: child,
    );
  }
}
