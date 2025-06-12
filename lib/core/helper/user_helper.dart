import 'dart:convert';
import 'dart:developer';

import 'package:albazar_app/Features/auth/data/models/user.dart';
import 'package:albazar_app/Features/auth/data/repositories/user_repo.dart';
import 'package:albazar_app/core/di/locator.dart';
import 'package:albazar_app/core/helper/secure_storage_helper.dart';
import 'package:albazar_app/core/helper/socket_helper.dart';
import 'package:albazar_app/core/utils/keys.dart';
import 'package:flutter/material.dart';

class UserHelper {
  const UserHelper._();

  static String? _token;
  static UserModel? _user;
  static bool get isLoggedIn => _token != null && _user != null;
  static UserModel? get user => _user;
  static String? get token => _token;
  static ValueNotifier<UserModel?> get userNotifier => _userNotifier;
  static final ValueNotifier<UserModel?> _userNotifier = ValueNotifier(_user);

  static Future<void> init() async {
    _token = await SecureStorageHelper.read(AppKeys.token);
    if (_token == null) return;
    final result = await refresh();
    if (result) return;
    final userData = await SecureStorageHelper.read(AppKeys.user);
    if (userData == null) return;
    final userMap = jsonDecode(userData);
    _user = UserModel.fromJson(userMap);
    _userNotifier.value = _user;
  }

  static Future<bool> refresh() async {
    try {
      log('refreshing user...');
      final user = await locator<IUserRepo>().getMe();

      SocketHelper.connect(queries: {
        "userId": user.id,
      });

      await SecureStorageHelper.write(
        AppKeys.user,
        jsonEncode(
          user.toJson(),
        ),
      );
      _userNotifier.value = user;
      _user = user;
      log("USER: $user");
      return true;
    } catch (e) {
      log("ERROR: $e");
      return false;
    }
  }

  static Future<void> setUser({
    required UserModel user,
    required String token,
  }) async {
    SocketHelper.connect(queries: {
      "userId": user.id,
    });
    await Future.wait([
      SecureStorageHelper.write(AppKeys.token, token),
      SecureStorageHelper.write(
        AppKeys.user,
        jsonEncode(
          user.toJson(),
        ),
      )
    ]);

    _token = token;
    _user = user;
    _userNotifier.value = user;
  }

  static Future<void> logout() async {
    _token = null;
    _user = null;
    _userNotifier.value = null;
    await Future.wait([
      SecureStorageHelper.delete(AppKeys.token),
      SecureStorageHelper.delete(AppKeys.user),
    ]);
    SocketHelper.disconnect();
  }
}
