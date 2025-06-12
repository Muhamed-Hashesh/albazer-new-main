import 'package:albazar_app/Features/auth/data/models/user.dart';
import 'package:equatable/equatable.dart';

class LoginResponse extends Equatable {
  final UserModel user;
  final String token;

  const LoginResponse({
    required this.user,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: UserModel.fromJson(json['data']),
      token: json['token'],
    );
  }

  @override
  List<Object?> get props => [user, token];
}
