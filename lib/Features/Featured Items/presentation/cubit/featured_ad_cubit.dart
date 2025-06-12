import 'package:albazar_app/Features/ads/data/models/ad.dart';
import 'package:albazar_app/Features/ads/data/repositories/ads_repository.dart';
import 'package:albazar_app/core/errors/exceptions.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'featured_ad_state.dart';

class FeaturedAdCubit extends Cubit<FeaturedAdState> {
  final IAdsRepo repository;
  FeaturedAdCubit({
    required this.repository,
  }) : super(const FeaturedAdInitial());

  Future<void> getFeaturedAds() async {
    try {
      emit(const FeaturedAdLoading());
      final ads = await repository.getFollowingAds();
      emit(FeaturedLoaded(ads: ads));
    } on AppException catch (e) {
      emit(FeaturedAdError(error: e.message));
    } catch (e) {
      emit(FeaturedAdError(error: e.toString()));
    }
  }

  Future<void> followUser({required String id}) async {
    try {
      emit(const FeaturedAdLoading());
      final message = await repository.follow(id: id);
      emit(UserFollowed(message: message));
    } on AppException catch (e) {
      emit(FeaturedAdError(error: e.message));
    } catch (e) {
      emit(FeaturedAdError(error: e.toString()));
    }
  }

  Future<void> unfollowUser({required String id}) async {
    try {
      emit(const FeaturedAdLoading());
      final message = await repository.unfollow(id: id);
      emit(UserFollowed(message: message));
    } on AppException catch (e) {
      emit(FeaturedAdError(error: e.message));
    } catch (e) {
      emit(FeaturedAdError(error: e.toString()));
    }
  }
}
