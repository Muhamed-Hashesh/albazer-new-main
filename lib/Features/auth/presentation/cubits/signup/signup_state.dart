part of 'signup_cubit.dart';

sealed class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object> get props => [];
}

final class SignupInitial extends SignupState {
  const SignupInitial();
}

final class SignupLoading extends SignupState {
  const SignupLoading();
}

class GoogleSignUp extends SignupState {
  final UserModel userModel;
  const GoogleSignUp(this.userModel);
}

final class SignupSuccess extends SignupState {
  final SignupResponse response;
  const SignupSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

final class SignupError extends SignupState {
  final String error;
  const SignupError({required this.error});

  @override
  List<Object> get props => [error];
}
