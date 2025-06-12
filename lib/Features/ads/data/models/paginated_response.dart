import 'package:albazar_app/Features/ads/data/models/ad.dart';
import 'package:equatable/equatable.dart';

class PaginationInfo extends Equatable {
  final int currentPage;
  final int limit;
  final int numberOfPages;
  final int totalResults;
  final int? next;

  const PaginationInfo({
    required this.currentPage,
    required this.limit,
    required this.numberOfPages,
    required this.totalResults,
    this.next,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      currentPage: json['currentPage'] ?? 1,
      limit: json['limit'] ?? 10,
      numberOfPages: json['numbeOfPage'] ?? 1,
      totalResults: json['totalResults'] ?? 0,
      next: json['next'],
    );
  }

  @override
  List<Object?> get props =>
      [currentPage, limit, numberOfPages, totalResults, next];
}

class PaginatedAdsResponse extends Equatable {
  final PaginationInfo paginate;
  final List<Ad> data;

  const PaginatedAdsResponse({
    required this.paginate,
    required this.data,
  });

  factory PaginatedAdsResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedAdsResponse(
      paginate: PaginationInfo.fromJson(json['paginate'] ?? {}),
      data: json['data'] != null
          ? List.from(json['data']).map((e) => Ad.fromJson(e)).toList()
          : [],
    );
  }

  @override
  List<Object> get props => [paginate, data];
}
