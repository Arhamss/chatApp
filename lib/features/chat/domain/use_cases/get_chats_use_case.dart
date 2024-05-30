import 'package:chat_app/core/failures.dart';
import 'package:chat_app/features/chat/domain/entities/chat_entity.dart';
import 'package:chat_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';

class GetChatsUseCase {
  GetChatsUseCase(this.repository);

  final ChatRepository repository;

  Future<Either<Failure, List<ChatEntity>>> call() async {
    return await repository.getChats();
  }
}
