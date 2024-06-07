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
    required this.phoneNumber,
    required this.receiverId,
  });

  final String chatId;
  final String phoneNumber;
  final String receiverId;

  @override
  Widget build(BuildContext context) {
    final sharedPreferencesHelper = GetIt.instance<SharedPreferencesHelper>();
    final fireBaseAuth = GetIt.instance<FirebaseAuth>();
    final firebaseFirestore = GetIt.instance<FirebaseFirestore>();
    final firebaseStorage = GetIt.instance<FirebaseStorage>();

    //Auth Repository
    final authRemoteDataSource = AuthRemoteDataSource(
      fireBaseAuth,
      firebaseFirestore,
    );

    final authLocalDataSource = AuthLocalDataSource(sharedPreferencesHelper);

    final userRepository = UserRepositoryImpl(
      authRemoteDataSource,
      authLocalDataSource,
      firebaseFirestore,
      firebaseStorage,
    );

    //Chat Repository
    final chatLocalDataSource = ChatLocalDataSource(sharedPreferencesHelper);
    final chatRemoteDataSource = ChatRemoteDataSource(firebaseFirestore);

    final chatRepository = ChatRepositoryImpl(
      remoteDataSource: chatRemoteDataSource,
      localDataSource: chatLocalDataSource,
    );

    //UseCases
    final sendMessageUseCase = SendMessageUseCase(
      chatRepository,
    );

    final loadChatMessageUseCase = LoadChatMessageUseCase(
      chatRepository,
    );

    final getUserByIdUseCase = GetUserByIdUseCase(userRepository);

    return BlocProvider(
      create: (context) => ChatBloc(
        sendMessageUseCase: sendMessageUseCase,
        loadChatMessageUseCase: loadChatMessageUseCase,
        getUserByIdUseCase: getUserByIdUseCase,
      )..add(
          LoadChatMessageEvent(
            chatId,
            receiverId,
          ),
        ),
      child: ChatView(
        chatId: chatId,
        phoneNumber: phoneNumber ,
        receiverId: receiverId,
      ),
    );
  }
}
