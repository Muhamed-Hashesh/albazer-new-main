part of 'list_users_cubit.dart';

class ListUsersState extends Equatable {
  final List<UserModel> users;
  final int numberOfUsers, page, limit;
  final RequestStatus status;
  final String error;
  final bool isLastPage;
  const ListUsersState({
    this.users = const [],
    this.numberOfUsers = 0,
    this.status = RequestStatus.initial,
    this.error = '',
    this.page = 1,
    this.limit = 20,
    this.isLastPage = false,
  });

  ListUsersState copyWith({
    List<UserModel>? users,
    int? numberOfUsers,
    RequestStatus? status,
    String? error,
    int? page,
    int? limit,
    bool? isLastPage,
  }) {
    return ListUsersState(
      users: users ?? this.users,
      numberOfUsers: numberOfUsers ?? this.numberOfUsers,
      status: status ?? this.status,
      error: error ?? this.error,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      isLastPage: isLastPage ?? this.isLastPage,
    );
  }

  @override
  List<Object?> get props =>
      [users, numberOfUsers, status, error, page, limit, isLastPage];
}
