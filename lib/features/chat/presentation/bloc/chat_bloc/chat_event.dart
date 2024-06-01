part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent(this.userId);

  final String userId;

  @override
  List<Object> get props => [
        userId,
      ];
}

class LoadChatsEvent extends ChatEvent {
  const LoadChatsEvent(super.userId);
}

class CreateChatEvent extends ChatEvent {
  const CreateChatEvent(
    super.userId,
    this.senderId,
    this.message,
  );

  final String senderId;
  final String message;

  @override
  List<Object> get props => [
        userId,
        senderId,
        message,
      ];
}
