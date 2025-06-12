import 'package:albazar_app/Features/category/data/models/category.dart';
import 'package:albazar_app/core/api/api_services.dart';
import 'package:albazar_app/core/api/urls.dart';
import 'package:albazar_app/core/errors/exceptions.dart';
import 'package:albazar_app/core/options/options.dart';

abstract class ICategoriesRepo {
  const ICategoriesRepo();

  Future<List<Category>> getCategories({required PaginationOptions options});
}

class CategoriesRepo implements ICategoriesRepo {
  final ApiService service;

  const CategoriesRepo({required this.service});

  @override
  Future<List<Category>> getCategories(
      {required PaginationOptions options}) async {
    final response = await service.get(
      endPoint: AppUrls.categories,
      queryParameters: options.toJson(),
    );
    if (response.containsKey("message") || response.containsKey("error")) {
      if (response.containsKey("error")) {
        throw AuthException(response['error']);
      }
      throw AuthException(response['message']);
    }
    final categories =
        (response['data'] as List).map((e) => Category.fromJson(e)).toList();
    return categories;
  }
}
