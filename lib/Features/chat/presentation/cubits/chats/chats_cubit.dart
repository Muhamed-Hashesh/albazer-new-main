import 'dart:developer';

import 'package:albazar_app/Features/chat/data/models/chat.dart';
import 'package:albazar_app/Features/chat/data/repositories/chat_repo.dart';
import 'package:albazar_app/core/enums/request_status.dart';
import 'package:albazar_app/core/errors/exceptions.dart';
import 'package:albazar_app/core/helper/socket_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  final IChatRepo repository;
  ChatsCubit({required this.repository})
      : super(
          const ChatsState(),
        ) {
    log("cubit created");
    SocketHelper.connect();
    SocketHelper.socket?.on("getOnlineUsers", _onGetOnlineUsers);
    SocketHelper.socket?.on("updateSidebar", _onUpdateChats);
  }

  void _onGetOnlineUsers(users) {
    log("data:$users");
    emit(
      state.copyWith(
        onlineUsers: List<String>.from(users),
      ),
    );
  }

  void _onUpdateChats(message) {
    log("newMessageReceived:$message");
    getChats();
    // emit(
    //   state.copyWith(
    //     onlineUsers: List<String>.from(users),
    //   ),
    // );
  }

  Future<void> getChats() async {
    try {
      emit(
        state.copyWith(
          status: RequestStatus.loading,
        ),
      );
      final chats = await repository.getChats();
      emit(
        state.copyWith(
          status: RequestStatus.success,
          chats: chats,
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
}
