import 'package:albazar_app/Features/ads/data/models/review.dart';
import 'package:albazar_app/Features/ads/data/repositories/ads_repository.dart';
import 'package:albazar_app/core/enums/request_status.dart';
import 'package:albazar_app/core/errors/exceptions.dart';
import 'package:albazar_app/core/helper/user_helper.dart';
import 'package:albazar_app/core/options/options.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'reviews_state.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  final IAdsRepo repository;
  ReviewsCubit({
    required this.repository,
  }) : super(const ReviewsState());

  Future<void> getReviews({required PaginationOptions options}) async {
    try {
      emit(state.copyWith(status: RequestStatus.loading));

      final newReviews = await repository.getAllReviews(options: options);
      final reviews = await repository.getAllReviews(options: options);
      emit(state.copyWith(
        reviews: [...newReviews].where((review) {
          return review.user.id == UserHelper.user!.id ||
              review.user.id != UserHelper.user!.id;
        }).toList(),
        isLastPage: reviews.length < options.limit,
        page: state.page + 1,
        status: RequestStatus.success,
        totalCount: reviews.length,
      ));

      // log('Fetched Reviews: ${filteredNew.length}');
    } on AppException catch (e) {
      emit(state.copyWith(
        status: RequestStatus.error,
        error: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: RequestStatus.error,
        error: e.toString(),
      ));
    }
  }
}
