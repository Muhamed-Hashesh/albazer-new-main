part of 'reset_password_cubit.dart';

sealed class ResetPasswordState extends Equatable {
  const ResetPasswordState();

  @override
  List<Object> get props => [];
}

final class ResetPasswordInitial extends ResetPasswordState {
  const ResetPasswordInitial();
}

final class ResetPasswordLoading extends ResetPasswordState {
  const ResetPasswordLoading();
}

final class ResetPasswordSuccess extends ResetPasswordState {
  final String token;
  const ResetPasswordSuccess({required this.token});

  @override
  List<Object> get props => [token];
}

final class ResetPasswordError extends ResetPasswordState {
  final String error;
  const ResetPasswordError({required this.error});

  @override
  List<Object> get props => [error];
}
