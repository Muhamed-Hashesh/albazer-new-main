import 'package:albazar_app/Features/category/data/repositories/categories_repo.dart';
import 'package:albazar_app/core/enums/request_status.dart';
import 'package:albazar_app/core/errors/exceptions.dart';
import 'package:albazar_app/core/options/options.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/category.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final ICategoriesRepo repository;
  CategoriesCubit({required this.repository}) : super(const CategoriesState());

  Future<void> getCategories({required PaginationOptions options}) async {
    try {
      emit(
        state.copyWith(
          status: RequestStatus.loading,
          error: '',
        ),
      );
      final categories = await repository.getCategories(options: options);
      emit(
        state.copyWith(
          categories: categories,
          status: RequestStatus.success,
          error: '',
        ),
      );
    } on AppException catch (e) {
      emit(
        state.copyWith(
          error: e.message,
          status: RequestStatus.error,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          error: e.toString(),
          status: RequestStatus.error,
        ),
      );
    }
  }
}
