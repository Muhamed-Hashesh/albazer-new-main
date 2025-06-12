import 'package:albazar_app/core/utils/serialization_helper.dart';
import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable implements SerializationHelper {
  final String id, senderId, receiverId, text, phone;
  final DateTime createdAt, updatedAt;

  const ChatMessage({
    required this.id,
    required this.phone,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['_id'] ?? '',
      phone: json['phone'] ?? '',
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      text: json['text'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        phone,
        senderId,
        receiverId,
        text,
        createdAt,
        updatedAt,
      ];

  @override
  Map<String, dynamic> toJson() => {
        "text": text,
      };
}

        // "_id": "67dc8ea25cc58b5d392b4b82",
        // "senderId": "67d895ddd73a072d2c82d25b",
        // "receiverId": "67d89120596a57bd6d84bbfc",
        // "text": "hii",
        // "createdAt": "2025-03-20T21:54:42.262Z",
        // "updatedAt": "2025-03-20T21:54:42.262Z",