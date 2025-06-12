import 'package:albazar_app/core/utils/serialization_helper.dart';
import 'package:equatable/equatable.dart';

class Category extends Equatable implements SerializationHelper {
  final String id, name, image;

  const Category({required this.id, required this.name, required this.image});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name, image];

  @override
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'image': image,
    };
  }
}
