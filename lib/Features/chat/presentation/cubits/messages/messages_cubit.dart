import 'dart:developer';

import 'package:albazar_app/Features/chat/data/models/chat_message.dart';
import 'package:albazar_app/Features/chat/data/repositories/chat_repo.dart';
import 'package:albazar_app/core/enums/request_status.dart';
import 'package:albazar_app/core/errors/exceptions.dart';
import 'package:albazar_app/core/helper/socket_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  final IChatRepo repository;
  MessagesCubit({required this.repository})
      : super(
          const MessagesState(),
        ) {
    SocketHelper.connect();
    SocketHelper.socket?.on("getOnlineUsers", _onGetOnlineUsers);
    SocketHelper.socket?.on("newMessage", _onNewMessage);
  }

  void _onGetOnlineUsers(users) {
    log("data:$users");
    emit(
      state.copyWith(
        isOnline: List<String>.from(users).contains(state.userId),
      ),
    );
  }

  // void _onNewMessage(message) {
  //   log("data:$message");
  //   final newMessage = ChatMessage.fromJson(message);
  //   emit(
  //     state.copyWith(
  //       messages: [newMessage, ...state.messages],
  //     ),
  //   );
  // }

  void _onNewMessage(message) {
  log("socket:newMessage:$message");
  final newMessage = ChatMessage.fromJson(message);

  // Only add message if it's in the current chat
  if ((newMessage.senderId == state.userId || newMessage.receiverId == state.userId ||!state.messages.any((msg) => msg.id == newMessage.id))) {
    emit(
      state.copyWith(
        messages: [newMessage, ...state.messages],
      ),
    );
  }
}


  Future<void> getMessages({required String id}) async {
    try {
      emit(
        state.copyWith(
          userId: id,
          status: RequestStatus.loading,
        ),
      );
    SocketHelper.connect();
    SocketHelper.socket?.on("getOnlineUsers", _onGetOnlineUsers);
    SocketHelper.socket?.on("newMessage", _onNewMessage);
      final messages = await repository.getMessages(id: id);
      emit(
        state.copyWith(
          status: RequestStatus.success,
          messages: messages.reversed.toList(),
        ),
      );
    } on AppException catch (e) {
      log(e.runtimeType.toString());
      emit(
        state.copyWith(
          status: RequestStatus.error,
          error: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RequestStatus.error,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> sendMessage({required ChatMessage message}) async {
    try {
      emit(
        state.copyWith(
          status: RequestStatus.loading,
          messages: [message, ...state.messages],
        ),
      );

      final sentMessage = await repository.sendMessage(message: message);
      final newMessages = List<ChatMessage>.from(state.messages);
      final index = newMessages.indexWhere((element) => element == message);
      if (index != -1) {
      newMessages[index] = sentMessage;
      log("newMessages:${newMessages[index].id}");
    }
      emit(
        state.copyWith(
          status: RequestStatus.success,
          messages: newMessages,
        ),
      );
    } on AppException catch (e) {
      log(e.runtimeType.toString());
      emit(
        state.copyWith(
          status: RequestStatus.error,
          error: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RequestStatus.error,
          error: e.toString(),
        ),
      );
    }
  }
  void disposeSocketListeners() {
  SocketHelper.socket?.off("getOnlineUsers");
  SocketHelper.socket?.off("newMessage");
}


}
