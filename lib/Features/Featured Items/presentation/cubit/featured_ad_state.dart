part of 'featured_ad_cubit.dart';

sealed class FeaturedAdState extends Equatable {
  const FeaturedAdState();

  @override
  List<Object> get props => [];
}

final class FeaturedAdInitial extends FeaturedAdState {
  const FeaturedAdInitial();
}

final class FeaturedAdLoading extends FeaturedAdState {
  const FeaturedAdLoading();
}

final class FeaturedLoaded extends FeaturedAdState {
  final List<Ad> ads;

  const FeaturedLoaded({required this.ads});

  @override
  List<Object> get props => [ads];
}

final class UserFollowed extends FeaturedAdState {
  final String message;

  const UserFollowed({required this.message});

  @override
  List<Object> get props => [message];
}

final class UserUnfollowed extends FeaturedAdState {
  final String message;

  const UserUnfollowed({required this.message});

  @override
  List<Object> get props => [message];
}

final class FeaturedAdError extends FeaturedAdState {
  final String error;

  const FeaturedAdError({required this.error});

  @override
  List<Object> get props => [error];
}
