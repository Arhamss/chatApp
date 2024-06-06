import 'package:chat_app/core/failures.dart';
import 'package:chat_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';

class SendMessageUseCase {
  SendMessageUseCase(this.repository);

  final ChatRepository repository;

  Future<Either<Failure, void>> call(
    String senderId,
    String text,
    String conversationId,
  ) async {
    return await repository.sendMessage(senderId, text, conversationId);
  }
}
