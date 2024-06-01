import 'package:chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_model.freezed.dart';

part 'message_model.g.dart';

@freezed
class MessageModel extends MessageEntity with _$MessageModel {
  const factory MessageModel({
    required String id,
    required String senderId,
    required String text,
    required DateTime timestamp,
    String? type,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, Object?> json) =>
      _$MessageModelFromJson(json);
}
