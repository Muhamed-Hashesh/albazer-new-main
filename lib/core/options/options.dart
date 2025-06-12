import 'package:albazar_app/core/options/queries_options.dart';

abstract class CommonOptions {}

abstract class OptionsWithSerialization implements CommonOptions {
  Map<String, dynamic> toJson();
}

final class LoginOptions implements OptionsWithSerialization {
  final String email, password;

  const LoginOptions({
    required this.email,
    required this.password,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

final class SignupOptions implements OptionsWithSerialization {
  final String firstName, lastName, phone, email, password;

  const SignupOptions({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.password,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'firstname': firstName,
      'lastname': lastName,
      'phone': phone,
      'email': email,
      'password': password,
    };
  }
}

final class ForgetPasswordOptions implements OptionsWithSerialization {
  final String email;

  const ForgetPasswordOptions({
    required this.email,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}

final class VerificationOptions implements OptionsWithSerialization {
  final String resetCode;

  const VerificationOptions({
    required this.resetCode,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'resetCode': resetCode,
    };
  }
}

final class ResetPasswordOptions implements OptionsWithSerialization {
  final String email, password;

  const ResetPasswordOptions({
    required this.email,
    required this.password,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

final class PaginationOptions implements OptionsWithSerialization {
  final int page, limit;
  final String? query, id;
  final QueryOptions? queryOptions;

  const PaginationOptions({
    this.page = 1,
    this.limit = 5,
    this.query,
    this.id,
    this.queryOptions,
  });

  PaginationOptions copyWith({
    int? page,
    int? limit,
    String? query,
    String? id,
    QueryOptions? queryOptions,
  }) =>
      PaginationOptions(
        page: page ?? this.page,
        limit: limit ?? this.limit,
        query: query ?? this.query,
        id: id ?? this.id,
        queryOptions: queryOptions ?? this.queryOptions,
      );

  @override
  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      if (query != null) 'keyword': query,
      ...?queryOptions?.toJson(),
    };
  }
}

final class ChangePasswordOptions implements OptionsWithSerialization {
  final String currentPassword, password, confirmPassword;

  const ChangePasswordOptions({
    required this.currentPassword,
    required this.password,
    required this.confirmPassword,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "currrentPassword": currentPassword,
      "password": password,
      "confirmPassword": confirmPassword
    };
  }
}

final class RatingOptions implements OptionsWithSerialization {
  final String id, title;
  final num rating;

  const RatingOptions({
    required this.id,
    required this.title,
    required this.rating,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'rating': rating,
    };
  }
}
