part of 'favorite_ad_cubit.dart';

sealed class FavoriteAdState extends Equatable {
  const FavoriteAdState();

  @override
  List<Object> get props => [];
}

final class FavoriteAdInitial extends FavoriteAdState {
  const FavoriteAdInitial();
}

final class FavoriteAdLoading extends FavoriteAdState {
  const FavoriteAdLoading();
}

final class FavoritesLoaded extends FavoriteAdState {
  final List<Ad> ads;

  const FavoritesLoaded({required this.ads});

  @override
  List<Object> get props => [ads];
}

final class FavoriteAdAdded extends FavoriteAdState {
  final String message;

  const FavoriteAdAdded({required this.message});

  @override
  List<Object> get props => [message];
}

final class FavoriteAdRemoved extends FavoriteAdState {
  final String message;

  const FavoriteAdRemoved({required this.message});

  @override
  List<Object> get props => [message];
}

final class FavoriteAdError extends FavoriteAdState {
  final String error;

  const FavoriteAdError({required this.error});

  @override
  List<Object> get props => [error];
}
