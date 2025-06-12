part of 'categories_cubit.dart';

class CategoriesState extends Equatable {
  final List<Category> categories;
  final String error;
  final RequestStatus status;
  const CategoriesState({
    this.categories = const [],
    this.error = '',
    this.status = RequestStatus.initial,
  });

  CategoriesState copyWith({
    List<Category>? categories,
    String? error,
    RequestStatus? status,
  }) {
    return CategoriesState(
      categories: categories ?? this.categories,
      error: error ?? this.error,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        categories,
        error,
        status,
      ];
}
