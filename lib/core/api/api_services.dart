import 'package:albazar_app/core/errors/exceptions.dart';
import 'package:albazar_app/core/helper/user_helper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiService {
  // final String _baseUrl = "https://albazar.onrender.com";
  final Dio _dio = Dio();

  Future<bool> _checkConnectivity() async {
    final isConnected = !(await Connectivity().checkConnectivity()).contains(
      ConnectivityResult.none,
    );

    return isConnected;
  }

  ApiService() {
    _dio.options
      ..sendTimeout = const Duration(seconds: 30)
      ..validateStatus = (status) => status! >= 400 && status <= 500;
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          debugPrint("Request Data: ${options.data}");
          final isConnected = await _checkConnectivity();

          if (!isConnected) {
            return handler.reject(DioException(
              requestOptions: options,
              type: DioExceptionType.connectionError,
            ));
          }
          final token = UserHelper.token;
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
        onResponse: (response, handler) async {
          debugPrint(response.requestOptions.toString());
          debugPrint(response.data.toString());
          if (response.statusCode == 403 ||
              response.data["message"].toString().toLowerCase().trim() ==
                  "expired token") {
            await UserHelper.logout();
            // if (navigatorKey.currentContext != null &&
            //     navigatorKey.currentContext!.mounted) {
            //   showDialog(
            //     context: navigatorKey.currentContext!,
            //     builder: (_) => const SessionExpiredDialog(),
            //   );
            // }
            return handler.reject(DioException(
              requestOptions: response.requestOptions,
              type: DioExceptionType.badCertificate,
            ));
          }
          if (response.statusCode == 500) {
            return handler.reject(DioException(
              requestOptions: response.requestOptions,
              type: DioExceptionType.unknown,
            ));
          }
          return handler.next(response);
        },
        onError: (error, handler) {
          debugPrint(error.requestOptions.toString());
          debugPrint(error.response.toString());
          return handler.next(error);
        },
      ),
    );
  }

  Future<dynamic> get({
    required String endPoint,
    Object? data,
    String? contentType,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? token = prefs.getString('auth-token') ?? '';

    try {
      var response = await _dio.get(
        endPoint,
        options: Options(contentType: contentType, headers: headers),
        queryParameters: queryParameters,
        data: data,
      );

      return response.data;
    } on DioException catch (e) {
      _checkException(e);
      return e.response!.data;
    }
  }

  Future<dynamic> post({
    required String endPoint,
    Object? data,
    String? contentType,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    // If headers are not provided, initialize them with Content-Type and Authorization
    // headers ??= {
    //   "Content-Type": "application/json",
    //   if (authToken != null) "Authorization": "Bearer $authToken",
    // };

    // // If headers are provided, add Authorization if authToken is available
    // if (authToken != null) {
    //   headers["Authorization"] = "Bearer $authToken";
    // }

    try {
      var response = await _dio.post(
        endPoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
          contentType: contentType,
          validateStatus: (status) {
            return status! < 500; // Accept status codes less than 500
          },
        ),
      );
      return response.data;
    } on DioException catch (e) {
      _checkException(e);
      return e.response!.data;
      // if ([
      //   DioExceptionType.badCertificate,
      //   DioExceptionType.unknown,
      //   DioExceptionType.cancel,
      //   DioExceptionType.badResponse
      // ].contains(e.type)) {
      //   return e.response!.data;
      // }
      // throw AppException.fromDioException(e);
    }
  }

  void _checkException(DioException ex) {
    if ([
      DioExceptionType.badCertificate,
      DioExceptionType.unknown,
      DioExceptionType.cancel,
      DioExceptionType.badResponse
    ].contains(ex.type)) {
      return;
    }

    // if (ex.type == DioExceptionType.badCertificate) {
    //   showDialog(
    //     context: navigatorKey.currentState!.context,
    //     builder: (_) => const SessionExpiredDialog(),
    //   );
    //   return;
    // }

    throw AppException.fromDioException(ex);
  }

  Future<dynamic> delete({
    required String endPoint,
    Object? data,
    String? contentType,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? token = prefs.getString('auth-token') ?? '';

    try {
      var response = await _dio.delete(
        endPoint,
        options: Options(contentType: contentType, headers: headers),
        queryParameters: queryParameters,
        data: data,
      );

      return response.data;
    } on DioException catch (e) {
      _checkException(e);
      return e.response!.data;
    }
  }

  Future<dynamic> put({
    required String endPoint,
    Object? data,
    String? contentType,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? token = prefs.getString('auth-token') ?? '';

    try {
      var response = await _dio.put(
        endPoint,
        options: Options(contentType: contentType, headers: headers),
        queryParameters: queryParameters,
        data: data,
      );

      return response.data;
    } on DioException catch (e) {
      _checkException(e);
      return e.response!.data;
    }
  }

  Future<dynamic> patch({
    required String endPoint,
    Object? data,
    String? contentType,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? token = prefs.getString('auth-token') ?? '';

    try {
      var response = await _dio.patch(
        endPoint,
        options: Options(contentType: contentType, headers: headers),
        queryParameters: queryParameters,
        data: data,
      );

      return response.data;
    } on DioException catch (e) {
      _checkException(e);
      return e.response!.data;
    }
  }

  // Future<Map<String, dynamic>> postUpdate({
  //   required String endPoint,
  //   required dynamic data,
  //   Map<String, dynamic>? queryParameters,
  // }) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   int? authId = prefs.getInt('auth-id') ?? 0;

  //   String url = '$_baseUrl$endPoint';
  //   if (queryParameters != null && queryParameters.isNotEmpty) {
  //     url += '?${Uri(queryParameters: queryParameters).query}';
  //   }

  //   var response = await _dio.post(
  //     url,
  //     data: data,
  //     options: Options(headers: {
  //       'Content-Type': 'application/json',
  //       // 'Authorization': 'Bearer $authId'
  //     }),
  //   );

  //   return response.data;
  // }
}

// final apiService = ApiService(Dio());