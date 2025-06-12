part of 'reviews_cubit.dart';

class ReviewsState extends Equatable {
  final List<Review> reviews;
  final RequestStatus status;
  final String error;
  final int page, limit;
  final bool isLastPage;
  final int? totalCount;
  const ReviewsState({
    this.reviews = const [],
    this.status = RequestStatus.initial,
    this.error = '',
    this.page = 1,
    this.limit = 10,
    this.isLastPage = false,
    this.totalCount = 0,
  });

  ReviewsState copyWith({
    List<Review>? reviews,
    RequestStatus? status,
    String? error,
    int? page,
    int? limit,
    bool? isLastPage,
    int? totalCount,
  }) {
    return ReviewsState(
      reviews: reviews ?? this.reviews,
      status: status ?? this.status,
      error: error ?? this.error,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      isLastPage: isLastPage ?? this.isLastPage,
      totalCount: totalCount ?? this.totalCount,
    );
  }

  @override
  List<Object> get props => [
        reviews,
        status,
        error,
        page,
        limit,
        isLastPage,
        totalCount!,
      ];
}
