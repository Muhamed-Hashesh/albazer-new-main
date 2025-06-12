import 'package:albazar_app/Features/ads/data/models/ad.dart';
import 'package:albazar_app/Features/ads/data/models/review.dart';
import 'package:albazar_app/Features/category/presentation/cubits/rating/rating_cubit.dart';
import 'package:albazar_app/Features/category/presentation/view/widget/rating_form_widget.dart';
import 'package:albazar_app/core/enums/request_status.dart';
import 'package:albazar_app/core/helper/messages.dart';
import 'package:albazar_app/core/helper/user_helper.dart';
import 'package:albazar_app/core/widgets/avatars/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewTile extends StatefulWidget {
  final Review review;
  final Ad? ad;
  final VoidCallback? onEdit;
  const ReviewTile({
    super.key,
    required this.review,
    this.onEdit,
    this.ad,
  });

  @override
  State<ReviewTile> createState() => _ReviewTileState();
}

class _ReviewTileState extends State<ReviewTile> {
  bool _canEdit = false;
  @override
  Widget build(BuildContext context) {
    if (_canEdit) {
      return BlocListener<RatingCubit, RatingState>(
        listener: (context, state) {
          if (state.status == RequestStatus.loading &&
              state.showLoadingOverlay) {
            AppMessages.showLoading(context);
          } else {
            AppMessages.hideLoading(context);
            if (state.status == RequestStatus.success &&
                state.message.isNotEmpty) {
              AppMessages.showSuccess(context, state.message);
              _canEdit = false;
              setState(() {});
            }
            if (state.status == RequestStatus.error) {
              AppMessages.showError(context, state.error);
            }
          }
        },
        child: RatingFormWidget(
          adId: widget.review.listing,
          review: widget.review,
          onClose: () => setState(() {
            _canEdit = false;
          }),
        ),
      );
    }
    String name =
        "${widget.review.user.firstName} ${widget.review.user.lastName}";
    if (widget.review.user.id == UserHelper.user!.id) name += " (انت)";
    // log("diff:${widget.review.updatedAt.isAfter(widget.review.createdAt)}");
    // if (!widget.review.updatedAt.isAtSameMomentAs(widget.review.createdAt)) {
    //   name += " (تم التعديل)";
    // }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () {
          // (context)
          //     .pushNamed(AppRoutes.ratting, arguments: widget.review.listing);
          // log("message: ${widget.review.listing}");
        },
        child: Card(
          color: Theme.of(context).highlightColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    UserAvatar(url: widget.review.user.profileImage ?? ''),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: Color(0xff8C8C8C),
                            fontSize: 16,
                            fontFamily: 'Noor',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        RatingBar.builder(
                          ignoreGestures: true,
                          initialRating: widget.review.rating.toDouble(),
                          minRating: 0,
                          itemSize: 25,
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
                    ),
                    if (widget.review.user.id == UserHelper.user!.id)
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _canEdit = true;
                                });
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            BlocListener<RatingCubit, RatingState>(
                              listener: (context, state) {
                                if (state.status == RequestStatus.loading &&
                                    state.showLoadingOverlay) {
                                  // AppMessages.showLoading(context);
                                } else {
                                  AppMessages.hideLoading(context);
                                  if (state.status == RequestStatus.success &&
                                      state.message.isNotEmpty) {
                                    AppMessages.showSuccess(
                                        context, state.message);
                                  }
                                  if (state.status == RequestStatus.error) {
                                    AppMessages.showError(context, state.error);
                                  }
                                }
                              },
                              child: IconButton(
                                onPressed: () async {
                                  final canDelete = await showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: const Text(
                                              'هل تريد حذف هذا التقييم؟'),
                                          actions: [
                                            TextButton(
                                                child: const Text('نعم'),
                                                onPressed: () {
                                                  Navigator.pop(context, true);
                                                  // context.pushNamed(
                                                  //     AppRoutes.categoryDetails,
                                                  //     arguments: widget.id);
                                                }),
                                            TextButton(
                                              child: const Text('لا'),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                            ),
                                          ],
                                        ),
                                      ) ??
                                      false;
                                  if (canDelete) {
                                    if (!context.mounted) return;

                                    context
                                        .read<RatingCubit>()
                                        .deleteReview(id: widget.review.id);
                                    // context.pushReplacementNamed(
                                    //     AppRoutes.categoryDetails,
                                    //     arguments: widget.ad);
                                  }
                                },
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  color: const Color(0xff8C8C8C).withOpacity(.5),
                  height: 1,
                  thickness: 1,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  widget.review.title,
                  // textAlign: TextAlign.right,x
                  maxLines: 4,
                  style: const TextStyle(
                    color: Color(0xff8C8C8C),
                    fontSize: 10,
                    fontFamily: 'Noor',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
