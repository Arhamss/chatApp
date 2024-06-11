import 'package:chat_app/core/failures.dart';
import 'package:chat_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';

class LoadOrCreateChatConversationUseCase {
  LoadOrCreateChatConversationUseCase(this.repository);

  final ChatRepository repository;

  Future<Either<Failure, String>> call(
    String userId,
    String contactId,
  ) async {
    return await repository.loadOrCreateConversation(
      userId,
      contactId,
    );
  }
}
