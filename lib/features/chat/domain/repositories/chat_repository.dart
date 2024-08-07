import 'dart:isolate';

import 'package:chat_app/core/failures.dart';
import 'package:chat_app/features/chat/domain/entities/conversation_entity.dart';
import 'package:chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

abstract class ChatRepository {
  Stream<Either<Failure, List<ConversationEntity>>> getChats(String userId);

  Future<Either<Failure, void>> sendMessage(
    String senderId,
    String text,
    String topicForNotification,
    String conversationId,
  );

  Future<Either<Failure, String>> loadOrCreateConversation(
    String userId,
    String contactId,
  );

  Stream<Either<Failure, List<MessageEntity>>> loadChatMessage(
    String conversationId,
  );

  Future<Either<Failure, void>> sendFile(
    XFile file,
    bool isVideo,
  );


}
