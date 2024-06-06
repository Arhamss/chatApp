part of 'chat_home_bloc.dart';

abstract class ChatHomeState extends Equatable {
  const ChatHomeState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatHomeState {}

class ChatLoading extends ChatHomeState {}

class ChatLoaded extends ChatHomeState {
  const ChatLoaded(this.chats, this.users);

  final List<ConversationEntity> chats;
  final List<UserEntity> users;

  @override
  List<Object> get props => [
        chats,
        users,
      ];
}

class ChatError extends ChatHomeState {
  const ChatError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class NavigateToChatScreen extends ChatHomeState {
  const NavigateToChatScreen(
    this.chatId,
    this.receiverId,
  );

  final String chatId;
  final String receiverId;

  @override
  List<Object> get props => [
        chatId,
        receiverId,
      ];
}
