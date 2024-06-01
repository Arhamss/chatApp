import 'dart:convert';
import 'package:chat_app/core/failures.dart';
import 'package:chat_app/features/chat/data/data_sources/chat_local_data_source.dart';
import 'package:chat_app/features/chat/data/data_sources/chat_remote_data_source.dart';

import 'package:chat_app/features/chat/data/models/conversation_model.dart';

import 'package:chat_app/features/chat/domain/entities/conversation_entity.dart';
import 'package:chat_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:logging/logging.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final ChatRemoteDataSource remoteDataSource;
  final ChatLocalDataSource localDataSource;
  final Logger logger = Logger('ChatRepositoryImpl');

  @override
  Future<Either<Failure, List<ConversationEntity>>> getChats(
    String userId,
  ) async {
    try {
      final remoteChats = await remoteDataSource.getChats(userId);
      localDataSource.cacheChats(
        remoteChats.map((chat) => jsonEncode(chat.toJson())).toList(),
      );
      return Right(remoteChats);
    } catch (e, stackTrace) {
      logger.severe('Failed to get chats for user $userId', e, stackTrace);
      final cachedChats = localDataSource.getCachedChats();
      if (cachedChats != null) {
        final chats = cachedChats
            .map(
              (chat) => ConversationModel.fromJson(
                jsonDecode(chat) as Map<String, dynamic>,
              ),
            )
            .toList();
        return Right(chats);
      }
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> loadOrCreateConversation(
    String userId,
    String contactId,
  ) async {
    try {
      final String? conversationId =
          await remoteDataSource.findConversation(userId, contactId);
      if (conversationId != null) {
        return Right(conversationId);
      } else {
        return Right(
          await remoteDataSource.createConversation([userId, contactId]),
        );
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> createChat(
    List<String> participantIds,
    String message,
    String senderId,
  ) async {
    try {
      await remoteDataSource.createChat(
        participantIds,
        message,
        senderId,
      );
      return const Right(null);
    } catch (e, stackTrace) {
      logger.severe('Failed to create chat for user $senderId', e, stackTrace);
      return Left(ServerFailure());
    }
  }
}
