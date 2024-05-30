import 'package:chat_app/core/failures.dart';
import 'package:chat_app/features/chat/domain/entities/chat_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<ChatEntity>>> getChats();
}
