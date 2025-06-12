import 'dart:developer';

import 'package:albazar_app/Features/auth/data/models/user.dart';
import 'package:albazar_app/Features/auth/data/repositories/user_repo.dart';
import 'package:albazar_app/core/errors/exceptions.dart';
import 'package:albazar_app/core/options/options.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final IUserRepo repository;
  ProfileCubit({
    required this.repository,
  }) : super(const ProfileInitial());

  Future<void> updateUser({required UserModel user}) async {
    try {
      emit(const ProfileLoading());
      await repository.updateUser(user: user);
      log('userData ${user.toJson()}');
      emit(const ProfileUpdated(message: "تم التحديث بنجاح"));
    } on AppException catch (e) {
      emit(ProfileError(error: e.message));
    } catch (e) {
      emit(ProfileError(error: e.toString()));
    }
  }

  Future<void> changePassword({required ChangePasswordOptions options}) async {
    try {
      emit(const ProfileLoading());
      await repository.changePassword(options: options);
      emit(const ProfileUpdated(message: "تم تغيير كلمة المرور بنجاح"));
    } on AppException catch (e) {
      emit(ProfileError(error: e.message));
    } catch (e) {
      emit(ProfileError(error: e.toString()));
    }
  }
}
