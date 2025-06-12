import 'package:albazar_app/Features/auth/data/repositories/auth_repo.dart';
import 'package:albazar_app/core/errors/exceptions.dart';
import 'package:albazar_app/core/options/options.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final IAuthRepo repository;
  ResetPasswordCubit({required this.repository})
      : super(const ResetPasswordInitial());

  Future<void> resetPassword(ResetPasswordOptions options) async {
    try {
      emit(const ResetPasswordLoading());
      final token = await repository.resetPassword(options);
      emit(ResetPasswordSuccess(token: token));
    } on AppException catch (e) {
      emit(ResetPasswordError(error: e.message));
    } catch (e) {
      emit(ResetPasswordError(error: e.toString()));
    }
  }
}
