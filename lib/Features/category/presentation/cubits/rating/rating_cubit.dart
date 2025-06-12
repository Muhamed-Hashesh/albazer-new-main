import 'dart:developer';

import 'package:albazar_app/Features/ads/data/models/review.dart';
import 'package:albazar_app/Features/ads/data/repositories/ads_repository.dart';
import 'package:albazar_app/core/enums/request_status.dart';
import 'package:albazar_app/core/errors/exceptions.dart';
import 'package:albazar_app/core/options/options.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'rating_state.dart';

class RatingCubit extends Cubit<RatingState> {
  final IAdsRepo repository;
  RatingCubit({
    required this.repository,
  }) : super(const RatingState());

  Future<void> rateAd({required RatingOptions options}) async {
    try {
      emit(state.copyWith(
        status: RequestStatus.loading,
        showLoadingOverlay: true,
      ));
      final message = await repository.rateAd(options: options);
      log("REVIEW: $message");
      emit(state.copyWith(
        status: RequestStatus.success,
        message: message,
      ));
      getMyReview(id: options.id);
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

  Future<void> getMyReview({required String id}) async {
    try {
      emit(state.copyWith(
        status: RequestStatus.loading,
        showLoadingOverlay: false,
        review: null,
        clearReview: true,
      ));
      final review = await repository.getMyReview(id: id);
      emit(state.copyWith(
          status: RequestStatus.success, review: review, message: ''));
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

  Future<void> updateReview({required RatingOptions options}) async {
    try {
      emit(state.copyWith(
        status: RequestStatus.loading,
        showLoadingOverlay: true,
      ));
      final review = await repository.updateMyReview(options: options);
      emit(state.copyWith(
        status: RequestStatus.success,
        review: review,
        message: "تم تحديث التقييم بنجاح",
      ));
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

  Future<void> deleteReview({required String id}) async {
    try {
      emit(state.copyWith(
        status: RequestStatus.loading,
        showLoadingOverlay: true,
      ));
      final message = await repository.deleteMyReview(id: id);
      emit(state.copyWith(
        status: RequestStatus.success,
        message: message,
        review: null,
      ));
      getMyReview(id: id);
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
