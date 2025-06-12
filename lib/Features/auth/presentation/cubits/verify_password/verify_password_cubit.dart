import 'package:albazar_app/Features/auth/data/repositories/auth_repo.dart';
import 'package:albazar_app/core/errors/exceptions.dart';
import 'package:albazar_app/core/options/options.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'verify_password_state.dart';

class VerifyPasswordCubit extends Cubit<VerifyPasswordState> {
  final IAuthRepo repository;
  VerifyPasswordCubit({required this.repository})
      : super(const VerifyPasswordInitial());

  Future<void> verify(VerificationOptions options) async {
    try {
      emit(const VerifyPasswordLoading());
      await repository.verify(options);
      emit(const VerifyPasswordSuccess());
    } on AppException catch (e) {
      emit(VerifyPasswordError(error: e.message));
    } catch (e) {
      emit(VerifyPasswordError(error: e.toString()));
    }
  }
}
