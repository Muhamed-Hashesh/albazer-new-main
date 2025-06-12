
import 'package:albazar_app/Features/chat/data/models/chat.dart';
import 'package:albazar_app/Features/chat/data/models/chat_message.dart';
import 'package:albazar_app/core/api/api_services.dart';
import 'package:albazar_app/core/api/urls.dart';
import 'package:albazar_app/core/errors/exceptions.dart';

abstract class IChatRepo {
  const IChatRepo();

  Future<ChatMessage> sendMessage({required ChatMessage message});
  Future<List<ChatMessage>> getMessages({required String id});
  Future<List<Chat>> getChats();
}

class ChatRepo extends IChatRepo {
  final ApiService service;

  const ChatRepo({required this.service});

  @override
  Future<List<Chat>> getChats() async {
    final response = await service.get(endPoint: AppUrls.chats);
    if (response is Map) {
      if (response.containsKey("message")) {
        throw AuthException(response["message"]);
      }
    }
    final chats = <Chat>[];
    for (var chat in response) {
      chats.add(Chat.fromJson(chat));
    }
    return chats;
  }

  @override
  Future<List<ChatMessage>> getMessages({required String id}) async {
    final response = await service.get(endPoint: "${AppUrls.message}/$id");
    if (response is Map) {
      if (response.containsKey("message")) {
        throw AuthException(response["message"]);
      }
    }
    final messages = <ChatMessage>[];
    for (var message in response) {
      messages.add(ChatMessage.fromJson(message));
    }
    return messages;
  }

  @override
  Future<ChatMessage> sendMessage({required ChatMessage message}) async {
    final response = await service.post(
      endPoint: "${AppUrls.message}/${message.receiverId}",
      data: message.toJson(),
    );
    return ChatMessage.fromJson(response["message"]);
  }
}
