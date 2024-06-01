import 'package:chat_app/features/chat/domain/entities/conversation_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_model.freezed.dart';

part 'conversation_model.g.dart';

@freezed
class ConversationModel extends ConversationEntity with _$ConversationModel {
  const factory ConversationModel({
    required String id,
    required List<String> participants,
    required String lastMessage,
    required DateTime lastMessageTime,
    required String lastMessageSender,
  }) = _ConversationModel;

  // factory ConversationModel.fromJson(Map<String, Object?> json) =>
  //     _$ConversationModelFromJson(json);

  factory ConversationModel.fromJson(Map<String, Object?> json) {
    json['lastMessageTime'] =
        (json['lastMessageTime']! as Timestamp).toDate().toString();
    return _$ConversationModelFromJson(json);
  }
}
