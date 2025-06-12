part of 'new_ad_cubit.dart';

sealed class NewAdState extends Equatable {
  const NewAdState();

  @override
  List<Object> get props => [];
}

final class NewAdInitial extends NewAdState {
  const NewAdInitial();
}

final class NewAdLoading extends NewAdState {
  const NewAdLoading();
}

final class NewAdSubmitted extends NewAdState {
  final String message;
  const NewAdSubmitted({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

final class NewAdError extends NewAdState {
  final String error;
  const NewAdError({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}
