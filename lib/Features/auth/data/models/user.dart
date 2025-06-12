import 'dart:developer';
import 'package:albazar_app/core/utils/serialization_helper.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import "package:http_parser/http_parser.dart";

class UserModel extends Equatable implements SerializationHelper {
  final String id, firstName, lastName, email, phone, password;
  final bool isActive;
  final String? about, slug, profileImage, passwordResetCode, city;
  final bool? passwordResetVerified;
  final DateTime? passwordResetExpired, passwordChangedAt, birthday;
  final UserRole role;
  final List<String> favorites, following, followers;
  final DateTime createdAt, updatedAt;
  final int balance;
  final int numberOfListing;

  const UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.balance,
    this.about,
    this.numberOfListing = 0,
    this.slug,
    this.profileImage,
    this.passwordResetCode,
    this.passwordResetVerified,
    this.passwordResetExpired,
    this.passwordChangedAt,
    required this.role,
    required this.favorites,
    required this.following,
    required this.followers,
    this.city,
    this.birthday,
  });

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        phone,
        password,
        isActive,
        about,
        slug,
        profileImage,
        passwordResetCode,
        passwordResetVerified,
        passwordResetExpired,
        passwordChangedAt,
        role,
        favorites,
        following,
        followers,
        city,
        birthday,
        createdAt,
        updatedAt,
        balance,
        numberOfListing
      ];

  factory UserModel.fromJson(Map<String, dynamic> json) {
    log("JSON:$json");
    return UserModel(
      id: json['_id'] ?? '',
      firstName: json['firstname'] ?? '',
      lastName: json['lastname'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone']?.toString() ?? '',
      password: json['password'] ?? '',
      isActive: json['active'] ?? false,
      about: json['about'],
      slug: json['slug'],
      profileImage: json['profileImage']?.toString().trim(),
      passwordResetCode: json['passwordResetCode'],
      passwordResetVerified: json['passwordResetVerified'],
      passwordResetExpired:
          DateTime.tryParse(json['passwordResetExpired'] ?? ''),
      // passwordChangedAt:
      //     DateTime.tryParse(json['passwordChangedAt']?.toString() ?? ''),
      // passwordChangedAt: json['passwordChangedAt'],
      role: UserRole.values.byName(json['role'] ?? 'user'),
      favorites: List.from(
        json['favourite'] ?? [],
      ),
      following: List.from(
        json['following'] ?? [],
      ),
      followers: List.from(
        json['followers'] ?? [],
      ),
      city: json['city'],
      birthday: DateTime.tryParse(json['birthday'] ?? ''),
      balance: json['Balance'] ?? 0,
      numberOfListing: json['numberOfListing'] ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstname': firstName,
      'lastname': lastName,
      'email': email,
      'phone': phone,
      'password': password,
      'active': isActive,
      'about': about,
      'slug': slug,
      'profileImage': profileImage,
      'passwordResetCode': passwordResetCode,
      'passwordResetVerified': passwordResetVerified,
      'passwordResetExpired': passwordResetExpired,
      'passwordChangedAt': passwordChangedAt,
      'role': role.name,
      'favourite': favorites,
      'following': following,
      'followers': followers,
      'city': city,
      'numberOfListing': numberOfListing,
      'birthday': birthday?.toIso8601String()
    };
  }

  UserModel copyWith(
          {String? id,
          String? firstName,
          String? lastName,
          String? email,
          String? phone,
          String? password,
          bool? isActive,
          String? about,
          String? slug,
          String? profileImage,
          String? passwordResetCode,
          bool? passwordResetVerified,
          DateTime? passwordResetExpired,
          DateTime? passwordChangedAt,
          UserRole? role,
          List<String>? favorites,
          List<String>? following,
          List<String>? followers,
          String? city,
          DateTime? birthday,
          DateTime? createdAt,
          DateTime? updatedAt,
          int? balance,
          int? numberOfListing}) =>
      UserModel(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        password: password ?? this.password,
        isActive: isActive ?? this.isActive,
        about: about ?? this.about,
        slug: slug ?? this.slug,
        profileImage: profileImage ?? this.profileImage,
        passwordResetCode: passwordResetCode ?? this.passwordResetCode,
        passwordResetVerified:
            passwordResetVerified ?? this.passwordResetVerified,
        passwordResetExpired: passwordResetExpired ?? this.passwordResetExpired,
        passwordChangedAt: passwordChangedAt ?? this.passwordChangedAt,
        role: role ?? this.role,
        favorites: favorites ?? this.favorites,
        following: following ?? this.following,
        followers: followers ?? this.followers,
        city: city ?? this.city,
        birthday: birthday ?? this.birthday,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        balance: balance ?? this.balance,
        numberOfListing: numberOfListing ?? this.numberOfListing,
      );

  Future<FormData> toFormData() async => FormData.fromMap({
        if (firstName.isNotEmpty) 'firstname': firstName,
        if (lastName.isNotEmpty) 'lastname': lastName,
        if (email.isNotEmpty) 'email': email,
        if (phone.isNotEmpty) 'phone': phone,
        if (password.isNotEmpty) 'password': password,
        'active': isActive,
        if (about != null) 'about': about,
        if (slug != null) 'slug': slug,
        if (profileImage != null && !profileImage!.contains("http"))
          'profileImage': await MultipartFile.fromFile(
            profileImage!,
            contentType: MediaType('image', profileImage!.split('.').last),
          ),
        if (passwordResetCode != null) 'passwordResetCode': passwordResetCode,
        if (passwordResetVerified != null)
          'passwordResetVerified': passwordResetVerified,
        if (passwordResetExpired != null)
          'passwordResetExpired': passwordResetExpired,
        if (passwordChangedAt != null) 'passwordChangedAt': passwordChangedAt,
        'role': role.name,
        'favourite': favorites,
        'following': following,
        'followers': followers,
        if (city != null) 'city': city,
        if (birthday != null) 'birthday': birthday?.toIso8601String(),
        // 'lastname': lastName,
        // 'email': email,
        // 'phone': phone,
        // 'password': password,
        // 'active': isActive,
        // 'about': about,
        // 'slug': slug,
        // 'profileImage': await MultipartFile.fromFile(profileImage!,
        //     contentType: MediaType(
        //       'image',
        //       profileImage!.split('.').last,
        //     )),
        // 'passwordResetCode': passwordResetCode,
        // 'passwordResetVerified': passwordResetVerified,
        // 'passwordResetExpired': passwordResetExpired,
        // 'passwordChangedAt': passwordChangedAt,
        // 'role': role.name,
        // 'favourite': favorites,
      });
}

enum UserRole {
  user,
  seller,
  admin,
}
