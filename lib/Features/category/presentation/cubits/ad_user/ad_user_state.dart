part of 'ad_user_cubit.dart';

sealed class AdUserState extends Equatable {
  const AdUserState();

  @override
  List<Object> get props => [];
}

final class AdUserInitial extends AdUserState {
  const AdUserInitial();
}

final class AdUserLoading extends AdUserState {
  const AdUserLoading();
}

final class AdUserLoaded extends AdUserState {
  final UserModel user;
  const AdUserLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

final class AdUserError extends AdUserState {
  final String error;
  const AdUserError({required this.error});

  @override
  List<Object> get props => [error];
}
