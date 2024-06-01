import 'package:chat_app/core/failures.dart';
import 'package:chat_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';

class CreateChatUseCase {
  CreateChatUseCase(this.repository);

  final ChatRepository repository;

  Future<Either<Failure, void>> call(
    List<String> participantsId,
    String message,
    String senderId,
  ) async {
    return await repository.createChat(participantsId, message, senderId);
  }
}
