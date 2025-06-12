import 'package:albazar_app/Features/auth/data/models/user.dart';
import 'package:albazar_app/Features/auth/data/repositories/user_repo.dart';
import 'package:albazar_app/core/errors/exceptions.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'ad_user_state.dart';

class AdUserCubit extends Cubit<AdUserState> {
  final IUserRepo repository;
  AdUserCubit({
    required this.repository,
  }) : super(const AdUserInitial());

  Future<void> getUser({required String id}) async {
    try {
      emit(
        const AdUserLoading(),
      );
      final user = await repository.getUser(id: id);
      emit(
        AdUserLoaded(user: user),
      );
    } on AppException catch (e) {
      emit(
        AdUserError(error: e.message),
      );
    } catch (e) {
      emit(
        AdUserError(error: e.toString()),
      );
    }
  }
}
