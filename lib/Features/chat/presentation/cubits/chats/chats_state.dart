part of 'chats_cubit.dart';

class ChatsState extends Equatable {
  final List<Chat> chats;
  final List<String> onlineUsers;
  final RequestStatus status;
  final String error;

  const ChatsState({
    this.chats = const [],
    this.onlineUsers = const [],
    this.status = RequestStatus.initial,
    this.error = '',
  });

  ChatsState copyWith({
    List<Chat>? chats,
    List<String>? onlineUsers,
    RequestStatus? status,
    String? error,
  }) {
    return ChatsState(
      chats: chats ?? this.chats,
      onlineUsers: onlineUsers ?? this.onlineUsers,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [
        chats,
        onlineUsers,
        status,
        error,
      ];
}
