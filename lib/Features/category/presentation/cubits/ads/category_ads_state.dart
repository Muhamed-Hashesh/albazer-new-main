part of 'category_ads_cubit.dart';

class CategoryAdsState extends Equatable {
  final List<Ad> ads;
  final RequestStatus status;
  final String error;
  final bool isLastPage;
  final int page;
  final int totalResults;
  final int totalPages;
  const CategoryAdsState({
    this.ads = const [],
    this.status = RequestStatus.initial,
    this.error = '',
    this.isLastPage = false,
    this.page = 1,
    this.totalResults = 0,
    this.totalPages = 1,
  });

  CategoryAdsState copyWith({
    List<Ad>? ads,
    RequestStatus? status,
    String? error,
    bool? isLastPage,
    int? page,
    int? totalResults,
    int? totalPages,
  }) {
    return CategoryAdsState(
      ads: ads ?? this.ads,
      status: status ?? this.status,
      error: error ?? this.error,
      isLastPage: isLastPage ?? this.isLastPage,
      page: page ?? this.page,
      totalResults: totalResults ?? this.totalResults,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  @override
  List<Object> get props => [
        ads,
        status,
        error,
        isLastPage,
        page,
        totalResults,
        totalPages,
      ];
}
