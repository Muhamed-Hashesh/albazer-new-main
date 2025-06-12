part of 'profile_cubit.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

final class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

final class ProfileUpdated extends ProfileState {
  final String message;
  const ProfileUpdated({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

final class ProfileError extends ProfileState {
  final String error;
  const ProfileError({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}
