import 'package:albazar_app/Features/auth/data/models/user.dart';
import 'package:albazar_app/Features/chat/data/models/chat_message.dart';
import 'package:equatable/equatable.dart';

class Chat extends Equatable {
  final UserModel user;
  final ChatMessage lastMessage;
  final ChatMessage phone;
  const Chat({
    required this.phone,
    required this.user,
    required this.lastMessage,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      user: UserModel.fromJson(json),
      lastMessage: ChatMessage.fromJson(json['lastMessage']),
      phone: ChatMessage.fromJson(json),
    );
  }

  @override
  List<Object?> get props => [user, lastMessage];
}
