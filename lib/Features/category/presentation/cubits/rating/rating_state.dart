part of 'rating_cubit.dart';

class RatingState extends Equatable {
  final Review? review;
  final RequestStatus status;
  final String error, message;
  final bool showLoadingOverlay;
  const RatingState({
    this.review,
    this.status = RequestStatus.initial,
    this.error = '',
    this.message = '',
    this.showLoadingOverlay = false,
  });

  RatingState copyWith(
      {Review? review,
      RequestStatus? status,
      String? error,
      String? message,
      bool? showLoadingOverlay,
      bool clearReview = false}) {
    return RatingState(
      review: clearReview ? null : review ?? this.review,
      status: status ?? this.status,
      error: error ?? this.error,
      message: message ?? this.message,
      showLoadingOverlay: showLoadingOverlay ?? this.showLoadingOverlay,
    );
  }

  @override
  List<Object?> get props => [
        review,
        status,
        error,
        message,
        showLoadingOverlay,
      ];
}

// final class RatingInitial extends RatingState {
//   const RatingInitial();
// }

// final class RatingLoading extends RatingState {
//   const RatingLoading();
// }

// final class ReviewLoaded extends RatingState {
//   @override
//   final Review? review;
//   const ReviewLoaded({
//     required this.review,
//   });

//   @override
//   List<Object?> get props => [review];
// }

// final class ReviewDeleted extends RatingState {
//   @override
//   final String message;
//   const ReviewDeleted({
//     required this.message,
//   });

//   @override
//   List<Object> get props => [message];
// }

// final class RatingError extends RatingState {
//   @override
//   final String error;
//   const RatingError({
//     required this.error,
//   });

//   @override
//   List<Object> get props => [error];
// }
