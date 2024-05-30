import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  const ChatEntity({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.profilePictureUrl,
    required this.lastMessageTime,
    required this.unreadCount,
  });

  final String id;
  final String name;
  final String lastMessage;
  final String profilePictureUrl;
  final DateTime lastMessageTime;
  final int unreadCount;

  @override
  List<Object?> get props =>
      [id, name, lastMessage, profilePictureUrl, lastMessageTime, unreadCount];
}
