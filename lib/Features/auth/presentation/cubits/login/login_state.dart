part of 'login_cubit.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

final class LoginInitial extends LoginState {
  const LoginInitial();
}

final class LoginLoading extends LoginState {
  const LoginLoading();
}

final class LoginSuccess extends LoginState {
  final LoginResponse response;
  const LoginSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

final class LoginWithGoogleSuccess extends LoginState {}

final class LoginError extends LoginState {
  final String error;
  const LoginError({required this.error});

  @override
  List<Object> get props => [error];
}
