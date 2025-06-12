import 'package:albazar_app/Features/auth/data/models/user.dart';
import 'package:albazar_app/core/api/api_services.dart';
import 'package:albazar_app/core/api/urls.dart';
import 'package:albazar_app/core/errors/exceptions.dart';
import 'package:albazar_app/core/helper/user_helper.dart';
import 'package:albazar_app/core/options/options.dart';

abstract class IUserRepo {
  const IUserRepo();
  Future<UserModel> getUser({required String id});
  Future<List<UserModel>> getUsers({required PaginationOptions options});
  Future<int> getNumberOfUsers();
  Future<UserModel> getMe();
  Future<void> updateUser({required UserModel user});
  Future<void> changePassword({required ChangePasswordOptions options});
}

class UserRepo extends IUserRepo {
  final ApiService service;
  const UserRepo({required this.service});

  @override
  Future<UserModel> getUser({required String id}) async {
    final response = await service.get(
      endPoint: "${AppUrls.user}/$id",
    );
    if (response.containsKey("message") || response.containsKey("error")) {
      if (response.containsKey("error")) {
        throw AuthException(response['error']);
      }
      throw AuthException(response['message']);
    }
    return UserModel.fromJson(response["data"]);
  }

  @override
  Future<UserModel> getMe() async {
    final response = await service.get(
      endPoint: AppUrls.getUser,
    );

    if (response.containsKey("message") || response.containsKey("error")) {
      if (response.containsKey("error")) {
        throw AuthException(response['error']);
      }
      throw AuthException(response['message']);
    }

    return UserModel.fromJson(response["data"]);
  }

  @override
  Future<void> updateUser({required UserModel user}) async {
    final response = await service.put(
      endPoint: "${AppUrls.user}/${user.id}",
      data: await user.toFormData(),
    );

    if (response.containsKey("message") || response.containsKey("error")) {
      if (response.containsKey("error")) {
        throw AuthException(response['error']);
      }
      throw AuthException(response['message']);
    }

    if (user.id == UserHelper.user!.id) {
      await UserHelper.refresh();
    }
  }

  @override
  Future<void> changePassword({required ChangePasswordOptions options}) async {
    final response = await service.post(
      endPoint: AppUrls.changePassword,
      data: options.toJson(),
    );

    if (response.containsKey("message") ||
        response.containsKey("error") ||
        response.containsKey("errors")) {
      if (response.containsKey("error")) {
        throw AuthException(response['error']);
      }
      if (response.containsKey("message")) {
        throw AuthException(response['message']);
      }
      throw const AuthException('حدث خطأ ما');
    }

    await UserHelper.refresh();
  }

  @override
  Future<int> getNumberOfUsers() async {
    final response = await service.get(
      endPoint: AppUrls.user,
    );

    if (response.containsKey("error")) {
      throw AuthException(response['error']);
    }
    if (response.containsKey("message")) {
      throw AuthException(response['message']);
    }
    return response["paginate"]["totalResults"];
  }

  @override
  Future<List<UserModel>> getUsers({required PaginationOptions options}) async {
    final response = await service.get(
      endPoint: AppUrls.user,
      queryParameters: options.toJson(),
    );

    if (response.containsKey("error")) {
      throw AuthException(response['error']);
    }
    if (response.containsKey("message")) {
      throw AuthException(response['message']);
    }
    return List.from(response['data'])
        .map((e) => UserModel.fromJson(e))
        .toList();
  }
}
