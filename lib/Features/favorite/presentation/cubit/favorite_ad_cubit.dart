import 'package:albazar_app/Features/ads/data/models/ad.dart';
import 'package:albazar_app/Features/ads/data/repositories/ads_repository.dart';
import 'package:albazar_app/core/errors/exceptions.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'favorite_ad_state.dart';

class FavoriteAdCubit extends Cubit<FavoriteAdState> {
  final IAdsRepo repository;
  FavoriteAdCubit({
    required this.repository,
  }) : super(const FavoriteAdInitial());

  Future<void> getFavoriteAds() async {
    try {
      emit(const FavoriteAdLoading());
      final ads = await repository.getFavoriteAds();
      emit(FavoritesLoaded(ads: ads));
    } on AppException catch (e) {
      emit(FavoriteAdError(error: e.message));
    } catch (e) {
      emit(FavoriteAdError(error: e.toString()));
    }
  }

  Future<void> addToFavorite({required String id}) async {
    try {
      emit(const FavoriteAdLoading());
      final message = await repository.addToFavorite(id: id);
      emit(FavoriteAdAdded(message: message));
    } on AppException catch (e) {
      emit(FavoriteAdError(error: e.message));
    } catch (e) {
      emit(FavoriteAdError(error: e.toString()));
    }
  }

  Future<void> removeFromFavorite({required String id}) async {
    try {
      emit(const FavoriteAdLoading());
      final message = await repository.removeFromFavorite(id: id);
      emit(FavoriteAdAdded(message: message));
    } on AppException catch (e) {
      emit(FavoriteAdError(error: e.message));
    } catch (e) {
      emit(FavoriteAdError(error: e.toString()));
    }
  }
}
