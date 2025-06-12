import 'package:albazar_app/Features/ads/data/models/ad.dart';
import 'package:albazar_app/Features/ads/data/repositories/ads_repository.dart';
import 'package:albazar_app/core/enums/request_status.dart';
import 'package:albazar_app/core/errors/exceptions.dart';
import 'package:albazar_app/core/options/queries_options.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'my_ads_state.dart';

class MyAdsCubit extends Cubit<MyAdsState> {
  final IAdsRepo repository;
  MyAdsCubit({
    required this.repository,
  }) : super(const MyAdsState());

  Future<void> getMyAds({
    required AdsQueryOptions options,
  }) async {
    try {
      emit(
        state.copyWith(
          status: RequestStatus.loading,
        ),
      );
      final ads = await repository.getMyAds(options: options);
      emit(
        state.copyWith(
          status: RequestStatus.success,
          ads: ads,
        ),
      );
    } on AppException catch (e) {
      emit(
        state.copyWith(
          status: RequestStatus.error,
          error: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RequestStatus.error,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> removeAd({required Ad ad}) async {
    try {
      emit(
        state.copyWith(
          status: RequestStatus.loading,
        ),
      );
      final message = await repository.removeAd(id: ad.id!);
      emit(
        state.copyWith(
          status: RequestStatus.success,
          message: message,
          ads: state.ads.where((element) => element.id != ad.id).toList(),
        ),
      );
    } on AppException catch (e) {
      emit(
        state.copyWith(
          status: RequestStatus.error,
          error: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RequestStatus.error,
          error: e.toString(),
        ),
      );
    }
  }
}
