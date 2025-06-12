part of 'approval_cubit.dart';

sealed class ApprovalState extends Equatable {
  const ApprovalState();

  @override
  List<Object> get props => [];
}

final class ApprovalInitial extends ApprovalState {
  const ApprovalInitial();
}

final class ApprovalLoading extends ApprovalState {
  const ApprovalLoading();
}

final class ApprovalSuccess extends ApprovalState {
  final String message;
  const ApprovalSuccess({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

final class ApprovalError extends ApprovalState {
  final String error;
  const ApprovalError({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}
