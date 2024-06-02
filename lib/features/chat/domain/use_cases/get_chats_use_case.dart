import 'package:chat_app/core/failures.dart';

import 'package:chat_app/features/chat/domain/entities/conversation_entity.dart';
import 'package:chat_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';

class GetChatsUseCase {
  GetChatsUseCase(this.repository);

  final ChatRepository repository;

  Stream<Either<Failure, List<ConversationEntity>>> call(
    String userId,
  ) {
    return repository.getChats(userId);
  }
}
