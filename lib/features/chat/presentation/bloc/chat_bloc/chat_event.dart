part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class SendMessageEvent extends ChatEvent {
  const SendMessageEvent(
    this.conversationId,
    this.senderId,
    this.phoneNumber,
    this.text,
    this.messages,
  );

  final String conversationId;
  final String senderId;
  final String phoneNumber;
  final String text;
  final List<MessageEntity> messages;

  @override
  List<Object> get props => [
        senderId,
        text,
        phoneNumber,
        conversationId,
        messages,
      ];
}

class LoadChatMessageEvent extends ChatEvent {
  const LoadChatMessageEvent(
    this.conversationId,
    this.receiverId,
  );

  final String conversationId;
  final String receiverId;

  @override
  List<Object> get props => [
        conversationId,
        receiverId,
      ];
}

class SendFileEvent extends ChatEvent{
  const SendFileEvent(this.file, this.isVideo);

  final XFile file;
  final bool isVideo;

  @override
  List<Object> get props => [file, isVideo];
}
