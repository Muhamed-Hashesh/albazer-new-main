import 'package:albazar_app/Features/auth/data/models/login_response.dart';
import 'package:albazar_app/Features/auth/data/models/signup_response.dart';
import 'package:albazar_app/Features/auth/data/models/user.dart';
import 'package:albazar_app/core/api/api_services.dart';
import 'package:albazar_app/core/api/urls.dart';
import 'package:albazar_app/core/errors/exceptions.dart';
import 'package:albazar_app/core/helper/user_helper.dart';
import 'package:albazar_app/core/options/options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class IAuthRepo {
  Future<LoginResponse> login(LoginOptions options);
  Future<SignupResponse> signup(SignupOptions options);
  Future<String> forgetPassword(ForgetPasswordOptions options);
  Future<void> verify(VerificationOptions options);
  Future<String> resetPassword(ResetPasswordOptions options);
  Future<UserModel> googleSignIn();
}

class AuthRepo implements IAuthRepo {
  final ApiService service;

  const AuthRepo({required this.service});

  @override
  Future<UserModel> googleSignIn() async {
    try {
      // 🔁 Force Google account picker
      await GoogleSignIn().signOut();
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw const AuthException("Google sign-in canceled");
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user == null) throw const AuthException("Google sign-in failed");

      // You can map this into your SignupOptions or LoginOptions
      String displayName = user.displayName ?? '';
      List<String> nameParts = displayName.trim().split(' ');

      final googleSignupOptions = SignupOptions(
          email: user.email ?? '',
          firstName: nameParts.isNotEmpty ? nameParts[0] : '',
          lastName: nameParts.length > 1 ? nameParts[1] : '',
          phone: user.phoneNumber ?? '',
          password: "");

      UserModel userModel = UserModel.fromJson(googleSignupOptions.toJson());

      return userModel;
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  Future<String> forgetPassword(ForgetPasswordOptions options) async {
    final response = await service.post(
      endPoint: AppUrls.forgetPassword,
      data: options.toJson(),
    );

    return response['message'];
  }

  @override
  Future<LoginResponse> login(LoginOptions options) async {
    final response = await service.post(
      endPoint: AppUrls.login,
      data: options.toJson(),
    );
    if (response.containsKey("message") || response.containsKey("error")) {
      if (response.containsKey("error")) {
        throw AuthException(response['error']);
      }
      throw AuthException(response['message']);
    }
    final loginResponse = LoginResponse.fromJson(response);
    await UserHelper.setUser(
        user: loginResponse.user, token: loginResponse.token);
    return loginResponse;
  }

  @override
  Future<String> resetPassword(ResetPasswordOptions options) async {
    final response = await service.post(
      endPoint: AppUrls.resetPassword,
      data: options.toJson(),
    );
    if (response.containsKey("message") || response.containsKey("error")) {
      if (response.containsKey("error")) {
        throw AuthException(response['error']);
      }
      throw AuthException(response['message']);
    }
    return response['token'];
  }

  @override
  Future<SignupResponse> signup(SignupOptions options) async {
    final response = await service.post(
      endPoint: AppUrls.signup,
      data: options.toJson(),
    );
    if (response.containsKey("message") || response.containsKey("error")) {
      if (response.containsKey("error")) {
        throw AuthException(response['error']);
      }
      throw AuthException(response['message']);
    }
    final signupResponse = SignupResponse.fromJson(response);
    await UserHelper.setUser(
        user: signupResponse.user, token: signupResponse.token);
    return signupResponse;
  }

  @override
  Future<void> verify(VerificationOptions options) async {
    final response = await service.post(
      endPoint: AppUrls.verifyResetCode,
      data: options.toJson(),
    );
    if (response.containsKey("message") || response.containsKey("error")) {
      if (response.containsKey("error")) {
        throw AuthException(response['error']);
      }
      throw AuthException(response['message']);
    }
  }
}
