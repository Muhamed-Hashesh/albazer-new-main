part of 'messages_cubit.dart';

class MessagesState extends Equatable {
  final List<ChatMessage> messages;
  final String userId;
  final bool isOnline;
  final RequestStatus status;
  final String error;

  const MessagesState({
    this.userId = '',
    this.messages = const [],
    this.isOnline = false,
    this.status = RequestStatus.initial,
    this.error = '',
  });

  MessagesState copyWith({
    String? userId,
    List<ChatMessage>? messages,
    bool? isOnline,
    RequestStatus? status,
    String? error,
  }) {
    return MessagesState(
      userId: userId ?? this.userId,
      messages: messages ?? this.messages,
      isOnline: isOnline ?? this.isOnline,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [
        userId,
        messages,
        isOnline,
        status,
        error,
      ];
}
