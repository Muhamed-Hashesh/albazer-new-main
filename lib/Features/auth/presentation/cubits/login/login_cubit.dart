import 'dart:developer';

import 'package:albazar_app/Features/auth/data/models/login_response.dart';
import 'package:albazar_app/Features/auth/data/repositories/auth_repo.dart';
import 'package:albazar_app/Features/notificatoins/notification_service.dart';
import 'package:albazar_app/core/errors/exceptions.dart';
import 'package:albazar_app/core/options/options.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final IAuthRepo repository;
  LoginCubit({required this.repository}) : super(const LoginInitial());

  Future<void> login(LoginOptions options) async {
    try {
      emit(const LoginLoading());
      final response = await repository.login(options);
      await NotificationService.init();
      log(response.toString());
      emit(LoginSuccess(response: response));
    } on AppException catch (e) {
      log(e.runtimeType.toString());
      emit(LoginError(error: e.message));
    } catch (e) {
      emit(LoginError(error: e.toString()));
    }
  }
}
