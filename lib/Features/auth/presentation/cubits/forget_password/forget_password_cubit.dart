import 'package:albazar_app/Features/auth/data/repositories/auth_repo.dart';
import 'package:albazar_app/core/errors/exceptions.dart';
import 'package:albazar_app/core/options/options.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final IAuthRepo repository;
  ForgetPasswordCubit({required this.repository})
      : super(const ForgetPasswordInitial());

  Future<void> forgetPassword(ForgetPasswordOptions options) async {
    try {
      emit(const ForgetPasswordLoading());
      final message = await repository.forgetPassword(options);
      emit(ForgetPasswordSuccess(message: message));
    } on AppException catch (e) {
      emit(ForgetPasswordError(error: e.message));
    } catch (e) {
      emit(ForgetPasswordError(error: e.toString()));
    }
  }
}
