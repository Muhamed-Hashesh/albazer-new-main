part of 'my_ads_cubit.dart';

class MyAdsState extends Equatable {
  final List<Ad> ads;
  final RequestStatus status;
  final String error, message;
  const MyAdsState({
    this.ads = const [],
    this.status = RequestStatus.initial,
    this.error = '',
    this.message = '',
  });

  MyAdsState copyWith({
    List<Ad>? ads,
    RequestStatus? status,
    String? error,
    String? message,
  }) {
    return MyAdsState(
      ads: ads ?? this.ads,
      status: status ?? this.status,
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
        ads,
        status,
        error,
        message,
      ];
}
