import 'dart:developer';

import 'package:albazar_app/Features/ads/data/models/ad.dart';
import 'package:albazar_app/Features/ads/data/models/review.dart';
import 'package:albazar_app/Features/category/presentation/cubits/reviews/reviews_cubit.dart';
import 'package:albazar_app/Features/category/presentation/view/widget/review_tile.dart';
import 'package:albazar_app/core/enums/request_status.dart';
import 'package:albazar_app/core/helper/user_helper.dart';
import 'package:albazar_app/core/options/options.dart';
import 'package:albazar_app/core/widgets/loading/custom_skeleton_widget.dart';
import 'package:albazar_app/core/widgets/loading/lazy_loading_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RattingScreen extends StatefulWidget {
  final Ad ad;
  final int count;
  const RattingScreen({super.key, required this.ad, required this.count});

  @override
  State<RattingScreen> createState() => _RattingScreenState();
}

class _RattingScreenState extends State<RattingScreen> {
  final ScrollController _scrollController = ScrollController();
  String? avarage;
  @override
  void initState() {
    // avarage = '2.2';
    avarage = widget.ad.ratingAverage != null
        ? double.tryParse(widget.ad.ratingAverage!.toString())
            ?.toStringAsFixed(1)
        : null;
    super.initState();
    context.read<ReviewsCubit>().getReviews(
          options: PaginationOptions(id: widget.ad.id),
        );
    log('Fetched Reviews: ${widget.ad.id!.length}');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<double> ratings = [
      (widget.ad.count5! / widget.ad.ratingQuantity!).toDouble(),
      (widget.ad.count4! / widget.ad.ratingQuantity!).toDouble(),
      (widget.ad.count3! / widget.ad.ratingQuantity!).toDouble(),
      (widget.ad.count2! / widget.ad.ratingQuantity!).toDouble(),
      (widget.ad.count1! / widget.ad.ratingQuantity!).toDouble(),
    ]; // Sample data

    final List<Color> colors = [
      Colors.green,
      Colors.green.shade600,
      Colors.yellow,
      Colors.orange,
      Colors.red
    ];

    final List<String> labels = [
      "5 Stars",
      "4 Stars",
      "3 Stars",
      "2 Stars",
      "1 Stars"
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 85,
              decoration: BoxDecoration(
                color: Theme.of(context).highlightColor,
              ),
              child: Image.asset("assets/images/logo2.png"),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          avarage ?? '0.0',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).hoverColor.withAlpha(128),
                            fontSize: 32,
                            fontFamily: 'Noor',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          children: [
                            Text(
                              'إجمالى ${widget.ad.ratingQuantity} تعليق',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color:
                                    Theme.of(context).hoverColor.withAlpha(128),
                                fontSize: 13,
                                fontFamily: 'Noor',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            RatingBar.builder(
                              ignoreGestures: true,
                              initialRating:
                                  widget.ad.ratingAverage?.toDouble() ?? 5.0,
                              minRating: 0,
                              itemSize: 20,
                              direction: Axis.horizontal,
                              itemCount: 5,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 0.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Color(0xffFFED00),
                              ),
                              unratedColor: const Color(0xffD9D9D9),
                              glow: false,
                              onRatingUpdate: (rating) {},
                            ),
                          ],
                        )
                      ],
                    ),
                    Column(
                      children: List.generate(ratings.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: Colors
                                            .grey[300], // Background track
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    FractionallySizedBox(
                                      widthFactor: widget.ad.ratingQuantity == 0
                                          ? 0
                                          : ratings[
                                              index], // Fills based on rating %
                                      child: Container(
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: colors[index],
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                labels[index],
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .hoverColor
                                      .withAlpha(128),
                                  fontSize: 12,
                                  fontFamily: 'Noor',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'التعليقات',
                      style: TextStyle(
                        color: Theme.of(context).hoverColor,
                        fontSize: 16,
                        fontFamily: 'Noor',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: BlocBuilder<ReviewsCubit, ReviewsState>(
                        builder: (context, state) {
                          if (state.status == RequestStatus.loading &&
                              state.reviews.isEmpty) {
                            return _buildLoading(); // Show loading for the first page
                          }
                          return LazyLoadingView.list(
                            items: state.reviews.map((review) {
                              return ReviewTile(
                                ad: widget.ad,
                                key: ValueKey(review
                                    .id), // Ensure each ReviewTile is unique
                                review: review,
                              );
                            }).toList(),
                            page: state.page,
                            limit: state.limit,
                            isLastPage: state.isLastPage,
                            isLoading: state.status == RequestStatus.loading,
                            scrollController: _scrollController,
                            loader: _buildLoadingTile(),
                            firstPageLoader: _buildLoading(),
                            onRequest: () {
                              context.read<ReviewsCubit>().getReviews(
                                    options: PaginationOptions(
                                      page: state.page,
                                      limit: state.limit,
                                      id: widget.ad.id,
                                      // id: '681b75b5e563ad15a6a15f9c'
                                    ),
                                  );
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingTile() => CustomSkeletonWidget(
        isLoading: true,
        child: ReviewTile(
          review: Review(
            id: '',
            title: '',
            rating: 0,
            listing: '',
            user: UserHelper.user!.copyWith(
              id: '',
            ),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ),
      );
  Widget _buildLoading() => ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 10,
        itemBuilder: (_, __) => _buildLoadingTile(),
      );
}
