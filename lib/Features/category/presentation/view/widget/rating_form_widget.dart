import 'package:albazar_app/Features/ads/data/models/ad.dart';
import 'package:albazar_app/Features/ads/data/models/review.dart';
import 'package:albazar_app/Features/auth/presentation/views/widgets/custom_button_login.dart';
import 'package:albazar_app/Features/category/presentation/cubits/ads/category_ads_cubit.dart';
import 'package:albazar_app/Features/category/presentation/cubits/rating/rating_cubit.dart';
import 'package:albazar_app/core/di/locator.dart';
import 'package:albazar_app/core/enums/request_status.dart';
import 'package:albazar_app/core/extensions/navigation_extension.dart';
import 'package:albazar_app/core/helper/messages.dart';
import 'package:albazar_app/core/options/options.dart';
import 'package:albazar_app/core/options/queries_options.dart';
import 'package:albazar_app/core/routes/routes.dart';
import 'package:albazar_app/core/widgets/fields/custom_labeled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingFormWidget extends StatefulWidget {
  final Ad? ad;
  final String? adId;
  final Review? review;
  // final String? ratingCount;
  // final String? ratingAvarage;
  final VoidCallback? onClose;
  const RatingFormWidget({
    super.key,
    this.ad,
    this.adId,
    this.review,
    this.onClose,
    // this.ratingCount,
    // this.ratingAvarage,
  });

  @override
  State<RatingFormWidget> createState() => _RatingFormWidgetState();
}

class _RatingFormWidgetState extends State<RatingFormWidget> {
  late double _rating = widget.review?.rating.toDouble() ?? 0;
  final TextEditingController _reviewController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _reviewController.text = widget.review?.title ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'قيم هذا الإعلان',
                style: TextStyle(
                  color: Theme.of(context).hoverColor,
                  fontSize: 16,
                  fontFamily: 'Noor',
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (widget.onClose != null)
                IconButton(
                  onPressed: widget.onClose,
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              RatingBar.builder(
                initialRating: _rating,
                minRating: 0,
                direction: Axis.horizontal,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Color(0xffFFED00),
                ),
                unratedColor: const Color(0xffD9D9D9),
                glow: false,
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
              const SizedBox(width: 20),

//BlocProvider(
              //   create: (context) => locator<ReviewsCubit>()
              //     ..getReviews(
              //       options: PaginationOptions(id: adId),
              //     ), // change the cubit to ratting.
              // ),

              // change the cubit to ratting.
              BlocProvider(
                create: (context) => locator<CategoryAdsCubit>()
                  ..getCategoryAds(
                    options: PaginationOptions(
                      queryOptions: AdsQueryOptions(
                        query: widget.ad?.adTitle,
                      ),
                    ),
                  ),
                child: BlocBuilder<CategoryAdsCubit, CategoryAdsState>(
                  builder: (context, state) {
                    if (state.status == RequestStatus.loading) {
                      // AppMessages.showLoading(context);
                      return const Center(
                        child: SizedBox(
                          width: 8,
                          height: 8,
                          child: CircularProgressIndicator(
                            color: Colors.yellow,
                          ),
                        ),
                      );
                    }
                    if (state.status == RequestStatus.error) {
                      return Center(
                        child: Text(state.error),
                      );
                    } else {
                      return InkWell(
                        onTap: () {
                          context.pushNamed(AppRoutes.ratting, arguments: {
                            'ad': widget.ad,
                            'count': state.ads[0].ratingQuantity!.toInt(),
                          });
                        },
                        child: Text(
                          '(${state.ads[0].ratingQuantity})',
                          style: const TextStyle(
                            color: Color(0xFF8C8C8C),
                            fontSize: 13,
                            fontFamily: 'Noor',
                            fontWeight: FontWeight.w400,
                            // decoration: TextDecoration.underline,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              // InkWell(
              //   onTap: () {
              //     context.pushNamed(AppRoutes.ratting, arguments: {
              //       'ad': widget.ad,
              //       'count': widget.count,
              //     });
              //     // Navigator.push(
              //     //     context,
              //     //     MaterialPageRoute(
              //     //       builder: (context) => RattingScreen(
              //     //         adId: widget.adId,
              //     //         ratingAvarage: widget.ratingAvarage,
              //     //         ratingCount: widget.ratingCount,
              //     //       ),
              //     //     ));
              //   },
              //   child: Text(
              //     '(${widget.ad!.ratingQuantity})',
              //     // '(${widget.count})',
              //     style: const TextStyle(
              //       color: Color(0xFF8C8C8C),
              //       fontSize: 13,
              //       fontFamily: 'Noor',
              //       fontWeight: FontWeight.w400,
              //       decoration: TextDecoration.underline,
              //     ),
              //   ),
              // ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          CustomLabeledTextField(
            controller: _reviewController,
            label: "اكتب تعليق على هذا الإعلان",
            maxLines: 5,
            hint: "اكتب تعليق...",
            validator: (review) {
              if (review == null || review.isEmpty) {
                return "الرجاء كتابة تعليق";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: CustomButtonAuth(
              title: "رفع التقييم",
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                if (_rating == 0) {
                  AppMessages.showError(
                      context, "الرجاء تقييم الإعلان من 1 إلى 5");
                  return;
                }
                if (widget.review != null) {
                  final options = RatingOptions(
                    id: widget.review!.id,
                    title: _reviewController.text.trim(),
                    rating: _rating,
                  );
                  context.read<RatingCubit>().updateReview(options: options);
                  // context.pushReplacementNamed(AppRoutes.categoryDetails,
                  //     arguments: widget.ad);
                  return;
                }
                final options = RatingOptions(
                  id: widget.ad!.id!,
                  title: _reviewController.text.trim(),
                  rating: _rating,
                );
                context.read<RatingCubit>().rateAd(options: options);
                // context.pushNamed(AppRoutes.categoryDetails,
                //     arguments: widget.ad);
              },
            ),
          ),
        ],
      ),
    );
  }
}
