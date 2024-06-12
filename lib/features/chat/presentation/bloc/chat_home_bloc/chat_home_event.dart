part of 'chat_home_bloc.dart';

abstract class ChatHomeEvent extends Equatable {
  const ChatHomeEvent();

  @override
  List<Object> get props => [];
}

class LoadChatsEvent extends ChatHomeEvent {
  const LoadChatsEvent(this.userId);

  final String userId;
}

class NavigationToChatScreenEvent extends ChatHomeEvent {
  const NavigationToChatScreenEvent(
    this.chatId,
    this.phoneNumber,
    this.receiverId,
  );
  final String phoneNumber;
  final String chatId;
  final String receiverId;

  @override
  List<Object> get props => [
        chatId,
        receiverId,
      ];
}
