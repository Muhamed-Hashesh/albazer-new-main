import 'dart:developer';

import 'package:albazar_app/Features/auth/data/models/signup_response.dart';
import 'package:albazar_app/Features/auth/data/models/user.dart';
import 'package:albazar_app/Features/auth/data/repositories/auth_repo.dart';
import 'package:albazar_app/core/errors/exceptions.dart';
import 'package:albazar_app/core/options/options.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final IAuthRepo repository;
  SignupCubit({required this.repository}) : super(const SignupInitial());
  static SignupCubit get(context) => BlocProvider.of(context);

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future<void> signup(SignupOptions options) async {
    try {
      emit(const SignupLoading());
      final response = await repository.signup(options);
      emit(SignupSuccess(response: response));
    } on AppException catch (e) {
      emit(SignupError(error: e.message));
    } catch (e) {
      emit(SignupError(error: e.toString()));
    }
  }

  // * Google Sign Up
  Future<void> googleSignUp() async {
    try {
      emit(const SignupLoading());
      final response = await repository.googleSignIn();
      firstNameController = TextEditingController(text: response.firstName);
      lastNameController = TextEditingController(text: response.lastName);
      emailController = TextEditingController(text: response.email);
      phoneController = TextEditingController(text: response.phone);
      emit(GoogleSignUp(response));
    } on AppException catch (e) {
      emit(SignupError(error: e.message));
      log("message: ${e.message}");
    } catch (e, s) {
      emit(SignupError(error: e.toString()));
      log("Google sign-in failed: $e", error: e, stackTrace: s);
    }
  }

  // * Apple Up
  Future<void> appleSignUp() async {
    try {
      emit(const SignupLoading());

      // Request Apple credentials
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Extract user information from the credential
      final String firstName = credential.givenName ?? "";
      final String lastName = credential.familyName ?? "";
      final String email =
          credential.email ?? ""; // Email may be null on first sign-in
      final String phone =
          ""; // You may need to collect the phone number separately if required

      // Set up text controllers for your fields
      firstNameController = TextEditingController(text: firstName);
      lastNameController = TextEditingController(text: lastName);
      emailController = TextEditingController(text: email);
      phoneController = TextEditingController(text: phone);

      // Create a response object to hold the user data
      // final response = UserResponse(
      //   firstName: firstName,
      //   lastName: lastName,
      //   email: email,
      //   phone: phone,
      // );

      // Emit success state with the response data
      log('Sucessfully ');
      // emit(AppleSignUp(response));
    } on AppException catch (e) {
      // Handle specific exceptions if any
      emit(SignupError(error: e.message));
      log("message: ${e.message}");
    } catch (e, s) {
      // Catch any other errors
      emit(SignupError(error: e.toString()));
      log("Apple sign-in failed: $e", error: e, stackTrace: s);
    }
  }
}
