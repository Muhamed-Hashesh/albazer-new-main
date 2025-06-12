import 'package:dio/dio.dart';

abstract class AppException implements Exception {
  final String message;

  const AppException(this.message);

  factory AppException.fromDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkException('تحقق من الاتصال بالانترنت');
      case DioExceptionType.badCertificate:
      case DioExceptionType.badResponse:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        return const ServerException("حدث خطأ ما");
    }
  }
}

final class SessionExpiredException extends AppException {
  const SessionExpiredException(super.message);
}

final class AuthException extends AppException {
  const AuthException(super.message);
}

final class NetworkException extends AppException {
  const NetworkException(super.message);
}

final class ServerException extends AppException {
  const ServerException(super.message);
}
