import 'dart:convert'; // Add this import
import 'package:chat_app/core/failures.dart';
import 'package:chat_app/features/chat/data/data_sources/chat_local_data_source.dart';
import 'package:chat_app/features/chat/data/data_sources/chat_remote_data_source.dart';
import 'package:chat_app/features/chat/data/models/chat_model.dart';
import 'package:chat_app/features/chat/domain/entities/chat_entity.dart';
import 'package:chat_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final ChatRemoteDataSource remoteDataSource;
  final ChatLocalDataSource localDataSource;

  @override
  Future<Either<Failure, List<ChatEntity>>> getChats() async {
    try {
      final remoteChats = await remoteDataSource.getChats();
      localDataSource.cacheChats(
        remoteChats.map((chat) => jsonEncode(chat.toJson())).toList(),
      );
      return Right(remoteChats);
    } catch (e) {
      final cachedChats = localDataSource.getCachedChats();
      if (cachedChats != null) {
        final chats = cachedChats
            .map(
              (chat) =>
                  ChatModel.fromJson(jsonDecode(chat) as Map<String, dynamic>),
            )
            .toList();
        return Right(chats);
      }
      return Left(ServerFailure());
    }
  }
}
