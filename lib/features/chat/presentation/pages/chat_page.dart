import 'package:chat_app/core/shared_preferences_helper.dart';
import 'package:chat_app/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:chat_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:chat_app/features/auth/data/repositories/user_repository_impl.dart';
import 'package:chat_app/features/chat/data/data_sources/chat_local_data_source.dart';
import 'package:chat_app/features/chat/data/data_sources/chat_remote_data_source.dart';
import 'package:chat_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:chat_app/features/chat/domain/use_cases/get_user_by_id_use_case.dart';
import 'package:chat_app/features/chat/domain/use_cases/load_chat_message_use_case.dart';
import 'package:chat_app/features/chat/domain/use_cases/send_message_use_case.dart';
import 'package:chat_app/features/chat/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:chat_app/features/chat/presentation/views/chat_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({
    super.key,
    required this.chatId,
    required this.receiverId,
  });

  final String chatId;
  final String receiverId;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthLocalDataSource>(
          create: (context) =>
              AuthLocalDataSource(GetIt.instance<SharedPreferencesHelper>()),
        ),
        RepositoryProvider<AuthRemoteDataSource>(
          create: (context) => AuthRemoteDataSource(
            GetIt.instance<FirebaseAuth>(),
            GetIt.instance<FirebaseFirestore>(),
          ),
        ),
        RepositoryProvider<UserRepositoryImpl>(
          create: (context) => UserRepositoryImpl(
            RepositoryProvider.of<AuthRemoteDataSource>(context),
            RepositoryProvider.of<AuthLocalDataSource>(context),
            GetIt.instance<FirebaseFirestore>(),
            GetIt.instance<FirebaseStorage>(),
          ),
        ),
        RepositoryProvider<ChatLocalDataSource>(
          create: (context) =>
              ChatLocalDataSource(GetIt.instance<SharedPreferencesHelper>()),
        ),
        RepositoryProvider<ChatRemoteDataSource>(
          create: (context) =>
              ChatRemoteDataSource(GetIt.instance<FirebaseFirestore>()),
        ),
        RepositoryProvider<ChatRepositoryImpl>(
          create: (context) => ChatRepositoryImpl(
            remoteDataSource:
                RepositoryProvider.of<ChatRemoteDataSource>(context),
            localDataSource:
                RepositoryProvider.of<ChatLocalDataSource>(context),
          ),
        ),
        RepositoryProvider<SendMessageUseCase>(
          create: (context) => SendMessageUseCase(
            RepositoryProvider.of<ChatRepositoryImpl>(context),
          ),
        ),
        RepositoryProvider<LoadChatMessageUseCase>(
          create: (context) => LoadChatMessageUseCase(
            RepositoryProvider.of<ChatRepositoryImpl>(context),
          ),
        ),
        RepositoryProvider<GetUserByIdUseCase>(
          create: (context) => GetUserByIdUseCase(
            RepositoryProvider.of<UserRepositoryImpl>(context),
          ),
        ),
      ],
      child: BlocProvider(
        create: (context) => ChatBloc(
          sendMessageUseCase:
              RepositoryProvider.of<SendMessageUseCase>(context),
          loadChatMessageUseCase:
              RepositoryProvider.of<LoadChatMessageUseCase>(context),
          getUserByIdUseCase:
              RepositoryProvider.of<GetUserByIdUseCase>(context),
        )..add(
            LoadChatMessageEvent(
              chatId,
              receiverId,
            ),
          ),
        child: ChatView(
          chatId: chatId,
          receiverId: receiverId,
        ),
      ),
    );
  }
}
