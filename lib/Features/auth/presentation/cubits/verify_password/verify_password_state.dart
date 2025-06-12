part of 'verify_password_cubit.dart';

sealed class VerifyPasswordState extends Equatable {
  const VerifyPasswordState();

  @override
  List<Object> get props => [];
}

final class VerifyPasswordInitial extends VerifyPasswordState {
  const VerifyPasswordInitial();
}

final class VerifyPasswordLoading extends VerifyPasswordState {
  const VerifyPasswordLoading();
}

final class VerifyPasswordSuccess extends VerifyPasswordState {
  const VerifyPasswordSuccess();
}

final class VerifyPasswordError extends VerifyPasswordState {
  final String error;
  const VerifyPasswordError({required this.error});

  @override
  List<Object> get props => [error];
}
