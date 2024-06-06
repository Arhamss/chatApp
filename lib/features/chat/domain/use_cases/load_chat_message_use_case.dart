import 'package:chat_app/core/failures.dart';

import 'package:chat_app/features/chat/domain/entities/conversation_entity.dart';
import 'package:chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:chat_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';

class LoadChatMessageUseCase {
  LoadChatMessageUseCase(this.repository);

  final ChatRepository repository;

  Stream<Either<Failure, List<MessageEntity>>> call(
    String conversationId,
  ) {
    return repository.loadChatMessage(
      conversationId,
    );
  }
}
