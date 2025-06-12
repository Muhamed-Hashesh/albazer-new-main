import 'dart:developer';

import 'package:albazar_app/Features/ads/data/models/ad.dart';
import 'package:albazar_app/Features/ads/data/repositories/ads_repository.dart';
import 'package:albazar_app/core/enums/request_status.dart';
import 'package:albazar_app/core/errors/exceptions.dart';
import 'package:albazar_app/core/options/options.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'category_ads_state.dart';

class CategoryAdsCubit extends Cubit<CategoryAdsState> {
  final IAdsRepo repository;
  CategoryAdsCubit({
    required this.repository,
  }) : super(const CategoryAdsState());

  void resetState() {
    emit(const CategoryAdsState());
  }

  Future<void> getCategoryAds({required PaginationOptions options}) async {
    if (state.status == RequestStatus.loading) return;
    try {
      emit(
        state.copyWith(
          status: RequestStatus.loading,
          error: '',
        ),
      );

      final response = await repository.getCategoryAds(
          options: options.copyWith(
        page: state.page,
      ));

      emit(
        state.copyWith(
          ads: [...state.ads, ...response.data],
          status: RequestStatus.success,
          error: '',
          page: state.page + 1,
          isLastPage: response.paginate.next == null ||
              response.paginate.currentPage >= response.paginate.numberOfPages,
          totalResults: response.paginate.totalResults,
          totalPages: response.paginate.numberOfPages,
        ),
      );
    } on AppException catch (e, s) {
      log('Error : $e  Stack : $s');
      emit(state.copyWith(error: e.message, status: RequestStatus.error));
    } catch (e, s) {
      log('Error : $e  Stack : $s');
      emit(state.copyWith(error: e.toString(), status: RequestStatus.error));
    }
  }

  Future<void> refreshCategoryAds({required PaginationOptions options}) async {
    if (state.status == RequestStatus.loading) return;
    try {
      emit(const CategoryAdsState(status: RequestStatus.loading));
      
      final response =
          await repository.getCategoryAds(options: options.copyWith(page: 1));

      // Detailed logging for debugging
      log("RefreshCategoryAds Response:");
      log("  - API Current Page: ${response.paginate.currentPage}");
      log("  - API Limit: ${response.paginate.limit}");
      log("  - API Total Pages: ${response.paginate.numberOfPages}");
      log("  - API Total Results: ${response.paginate.totalResults}");
      log("  - API Next Page: ${response.paginate.next}");
      log("  - Data Count: ${response.data.length}");

      emit(
        state.copyWith(
          ads: response.data,
          status: RequestStatus.success,
          error: '',
          page: response.paginate.currentPage,
          isLastPage: response.paginate.next == null ||
              response.paginate.currentPage >= response.paginate.numberOfPages,
          totalResults: response.paginate.totalResults,
          totalPages: response.paginate.numberOfPages,
        ),
      );
    } on AppException catch (e) {
      emit(state.copyWith(error: e.message, status: RequestStatus.error));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), status: RequestStatus.error));
    }
  }

  Future<void> goToPage(
      {required int pageNumber, required PaginationOptions options}) async {
    if (state.status == RequestStatus.loading) return;
    try {
      log("Going to page: $pageNumber");
      emit(state.copyWith(status: RequestStatus.loading, error: ''));

      final response = await repository.getCategoryAds(
        options: options.copyWith(page: pageNumber),
      );

      log("GoToPage Response for page $pageNumber:");
      log("  - API Current Page: ${response.paginate.currentPage}");
      log("  - API Limit: ${response.paginate.limit}");
      log("  - API Total Pages: ${response.paginate.numberOfPages}");
      log("  - API Total Results: ${response.paginate.totalResults}");
      log("  - API Next Page: ${response.paginate.next}");
      log("  - Data Count: ${response.data.length}");

      emit(
        state.copyWith(
          ads: response.data,
          status: RequestStatus.success,
          error: '',
          page: response.paginate.currentPage,
          isLastPage: response.paginate.next == null ||
              response.paginate.currentPage >= response.paginate.numberOfPages,
          totalResults: response.paginate.totalResults,
          totalPages: response.paginate.numberOfPages,
        ),
      );
    } on AppException catch (e, s) {
      log('Error : $e  Stack : $s');
      emit(state.copyWith(error: e.message, status: RequestStatus.error));
    } catch (e, s) {
      log('Error : $e  Stack : $s');
      emit(state.copyWith(error: e.toString(), status: RequestStatus.error));
    }
  }
}
