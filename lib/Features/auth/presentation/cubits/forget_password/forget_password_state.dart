part of 'forget_password_cubit.dart';

sealed class ForgetPasswordState extends Equatable {
  const ForgetPasswordState();

  @override
  List<Object> get props => [];
}

final class ForgetPasswordInitial extends ForgetPasswordState {
  const ForgetPasswordInitial();
}

final class ForgetPasswordLoading extends ForgetPasswordState {
  const ForgetPasswordLoading();
}

final class ForgetPasswordSuccess extends ForgetPasswordState {
  final String message;
  const ForgetPasswordSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

final class ForgetPasswordError extends ForgetPasswordState {
  final String error;
  const ForgetPasswordError({required this.error});

  @override
  List<Object> get props => [error];
}
