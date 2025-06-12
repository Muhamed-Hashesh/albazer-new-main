import 'dart:developer';

import 'package:albazar_app/Features/auth/data/models/user.dart';
import 'package:albazar_app/Features/auth/data/repositories/user_repo.dart';
import 'package:albazar_app/core/enums/request_status.dart';
import 'package:albazar_app/core/errors/exceptions.dart';
import 'package:albazar_app/core/options/options.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'list_users_state.dart';

class ListUsersCubit extends Cubit<ListUsersState> {
  final IUserRepo repository;
  ListUsersCubit({
    required this.repository,
  }) : super(const ListUsersState());

  Future<void> getUsers({required PaginationOptions options}) async {
    if (state.status == RequestStatus.loading) return;
    try {
      emit(
        state.copyWith(
          status: RequestStatus.loading,
          error: '',
          // page: state.page,
          // isLastPage: options.page == 1 ? false : state.isLastPage,
        ),
      );
      final users = await repository.getUsers(
          options: options.copyWith(
        page: state.page,
      ));
      emit(
        state.copyWith(
          users: [...state.users, ...users],
          status: RequestStatus.success,
          error: '',
          page: state.page + 1,
          isLastPage: users.length < options.limit,
        ),
      );
    } on AppException catch (e) {
      emit(state.copyWith(error: e.message, status: RequestStatus.error));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), status: RequestStatus.error));
    }
  }

  Future<void> getNumberOfUsers() async {
    if (state.status == RequestStatus.loading) return;
    try {
      emit(
        state.copyWith(
          status: RequestStatus.loading,
          error: '',
          // page: state.page,
          // isLastPage: options.page == 1 ? false : state.isLastPage,
        ),
      );
      final numberOfUsers = await repository.getNumberOfUsers();
      emit(
        state.copyWith(
          numberOfUsers: numberOfUsers,
          status: RequestStatus.success,
        ),
      );
    } on AppException catch (e) {
      emit(state.copyWith(error: e.message, status: RequestStatus.error));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), status: RequestStatus.error));
    }
  }

  Future<void> refreshUsers({required PaginationOptions options}) async {
    try {
      emit(
        state.copyWith(
          status: RequestStatus.loading,
          users: [],
          error: '',
          page: 1,
          isLastPage: false,
        ),
      );
      final users = await repository.getUsers(options: options);
      log("users: $users");
      emit(
        state.copyWith(
          users: users,
          status: RequestStatus.success,
          error: '',
          page: state.page + 1,
          isLastPage: users.length < options.limit,
        ),
      );
    } on AppException catch (e) {
      emit(state.copyWith(error: e.message, status: RequestStatus.error));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), status: RequestStatus.error));
    }
  }
}
