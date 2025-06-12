import 'package:albazar_app/Features/auth/data/models/user.dart';
import 'package:equatable/equatable.dart';

class SignupResponse extends Equatable {
  final UserModel user;
  final String token;

  const SignupResponse({
    required this.user,
    required this.token,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      user: UserModel.fromJson(json['data']),
      token: json['token'],
    );
  }

  @override
  List<Object?> get props => [user, token];
}
