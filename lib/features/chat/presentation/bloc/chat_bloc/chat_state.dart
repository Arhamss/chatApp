part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class MessageLoading extends ChatState {}

class MessageLoaded extends ChatState {
  const MessageLoaded(this.messages, this.user);

  final List<MessageEntity> messages;
  final UserEntity user;

  @override
  List<Object> get props => [messages, user];
}

class MessageSent extends ChatState {}

class MessageError extends ChatState {
  const MessageError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
