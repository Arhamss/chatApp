import 'dart:convert';
import 'package:chat_app/core/failures.dart';
import 'package:chat_app/features/chat/data/data_sources/chat_local_data_source.dart';
import 'package:chat_app/features/chat/data/data_sources/chat_remote_data_source.dart';
import 'package:chat_app/features/chat/data/models/conversation_model.dart';
import 'package:chat_app/features/chat/data/models/message_model.dart';
import 'package:chat_app/features/chat/domain/entities/conversation_entity.dart';
import 'package:chat_app/features/chat/domain/entities/message_entity.dart';
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
  Stream<Either<Failure, List<ConversationEntity>>> getChats(
    String userId,
  ) async* {
    try {
      final remoteStream = remoteDataSource.getChats(userId);
      yield* remoteStream.map((remoteChats) {
        localDataSource.cacheChats(
          remoteChats.map((chat) => jsonEncode(chat.toJson())).toList(),
        );
        return Right<Failure, List<ConversationEntity>>(remoteChats);
      }).handleError((Object error) {
        logger.severe('Failed to get chats for user $userId', error);
        final cachedChats = localDataSource.getCachedChats();
        if (cachedChats != null) {
          final chats = cachedChats.map((chat) {
            return ConversationModel.fromJson(
              jsonDecode(chat) as Map<String, dynamic>,
            );
          }).toList();
          return Right<Failure, List<ConversationEntity>>(chats);
        }
        return Left<Failure, List<ConversationEntity>>(ServerFailure());
      });
    } catch (e) {
      logger.severe('Unexpected error while getting chats for user $userId', e);
      yield Left(ServerFailure());
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
  Future<Either<Failure, void>> sendMessage(
    String senderId,
    String text,
    String topicForNotification,
    String conversationId,
  ) async {
    try {
      final userId = await remoteDataSource.getCurrentUserId(); 
      final currentUserName = localDataSource.getUserDetails(userId);
      print("this is current User ---------${currentUserName}");

      final jsonObject = jsonDecode(currentUserName!);
  
      // Access values from the JSON object
      String firstName = jsonObject['firstName'].toString();
      String lastName = jsonObject['lastName'].toString();

      print("this is firstname User ---------${firstName}");
      await remoteDataSource.sendMessage(
        senderId,
        text,
        topicForNotification,
        '$firstName $lastName',
        conversationId,
      );
      return const Right(null);
    } catch (e, stackTrace) {
      logger.severe(
        'Failed to send chat in conversation $conversationId',
        e,
        stackTrace,
      );
      return Left(ServerFailure());
    }
  }

  @override
  Stream<Either<Failure, List<MessageEntity>>> loadChatMessage(
    String conversationId,
  ) async* {
    try {
      final remoteStream = remoteDataSource.loadChatMessage(conversationId);
      yield* remoteStream.map((remoteMessages) {
        localDataSource.cacheMessages(
          remoteMessages
              .map((message) => jsonEncode(message.toJson()))
              .toList(),
          conversationId,
        );
        return Right<Failure, List<MessageEntity>>(remoteMessages);
      }).handleError((Object error) {
        logger.severe(
          'Failed to get messages for conversation: $conversationId',
          error,
        );
        final cachedMessages =
            localDataSource.getCachedMessages(conversationId);
        if (cachedMessages != null) {
          final messages = cachedMessages.map((message) {
            return MessageModel.fromJson(
              jsonDecode(message) as Map<String, dynamic>,
            );
          }).toList();
          return Right<Failure, List<MessageEntity>>(messages);
        }
        return Left<Failure, List<MessageEntity>>(ServerFailure());
      });
    } catch (e) {
      logger.severe(
        'Unexpected error while getting messages for conversation $conversationId',
        e,
      );
      yield Left(ServerFailure());
    }
  }
}
