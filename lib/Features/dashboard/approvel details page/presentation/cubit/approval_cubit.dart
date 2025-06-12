import 'package:albazar_app/Features/ads/data/repositories/ads_repository.dart';
import 'package:albazar_app/core/errors/exceptions.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'approval_state.dart';

class ApprovalCubit extends Cubit<ApprovalState> {
  final IAdsRepo repository;
  ApprovalCubit({
    required this.repository,
  }) : super(const ApprovalInitial());

  Future<void> accept({required String id}) async {
    try {
      emit(const ApprovalLoading());
      final message = await repository.accept(id: id);
      emit(ApprovalSuccess(message: message));
    } on AppException catch (e) {
      emit(ApprovalError(error: e.message));
    } catch (e) {
      emit(ApprovalError(error: e.toString()));
    }
  }

  Future<void> reject({required String id}) async {
    try {
      emit(const ApprovalLoading());
      final message = await repository.reject(id: id);
      emit(ApprovalSuccess(message: message));
    } on AppException catch (e) {
      emit(ApprovalError(error: e.message));
    } catch (e) {
      emit(ApprovalError(error: e.toString()));
    }
  }
}
