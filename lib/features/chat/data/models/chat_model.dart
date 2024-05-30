import 'package:chat_app/features/chat/domain/entities/chat_entity.dart';

class ChatModel extends ChatEntity {
  const ChatModel({
    required super.id,
    required super.name,
    required super.lastMessage,
    required super.profilePictureUrl,
    required super.lastMessageTime,
    required super.unreadCount,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      lastMessage: json['lastMessage'] as String? ?? '',
      profilePictureUrl: json['profilePictureUrl'] as String? ?? '',
      lastMessageTime: DateTime.parse(
        json['lastMessageTime'] as String? ?? DateTime.now().toIso8601String(),
      ),
      unreadCount: json['unreadCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lastMessage': lastMessage,
      'profilePictureUrl': profilePictureUrl,
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'unreadCount': unreadCount,
    };
  }
}
