part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  const ChatLoaded(this.chats);

  final List<ConversationEntity> chats;

  @override
  List<Object> get props => [chats];
}

class ChatError extends ChatState {
  const ChatError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
