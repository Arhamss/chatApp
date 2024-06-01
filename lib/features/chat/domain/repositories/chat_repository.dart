import 'package:chat_app/core/failures.dart';

import 'package:chat_app/features/chat/domain/entities/conversation_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<ConversationEntity>>> getChats(
    String userId,
  );

  Future<Either<Failure, void>> createChat(
    List<String> participantIds,
    String message,
    String senderId,
  );

  Future<Either<Failure, String>> loadOrCreateConversation(
    String userId,
    String contactId,
  );
}
