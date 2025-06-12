import 'package:albazar_app/Features/auth/data/models/user.dart';
import 'package:equatable/equatable.dart';

class Review extends Equatable {
  final String id, title, listing;
  final num rating;
  final UserModel user;
  final DateTime createdAt, updatedAt;

  const Review({
    required this.id,
    required this.title,
    required this.listing,
    required this.rating,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json['_id'] ?? '',
        title: json['title'] ?? '',
        listing: json['listing'] ?? '',
        rating: json['rating'] ?? 0,
        user: UserModel.fromJson(json['user'] ?? {}),
        createdAt:
            DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
        updatedAt:
            DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      );

  @override
  List<Object?> get props =>
      [id, title, listing, rating, user, createdAt, updatedAt];
}
