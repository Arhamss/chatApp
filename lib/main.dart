import 'package:chat_app/core/router/app_router.dart';
import 'package:chat_app/core/shared_preferences_helper.dart';
import 'package:chat_app/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:chat_app/features/auth/data/data_sources/auth_remote_data_source_impl.dart';
import 'package:chat_app/features/auth/data/repositories/user_repository_impl.dart';
import 'package:chat_app/features/auth/domain/use_cases/auth_use_cases.dart';
import 'package:chat_app/features/auth/domain/use_cases/save_profile_use_cases.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:chat_app/features/auth/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:chat_app/features/chat/data/data_sources/chat_local_data_source.dart';
import 'package:chat_app/features/chat/data/data_sources/chat_remote_data_source.dart';
import 'package:chat_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:chat_app/features/chat/domain/use_cases/get_chats_use_case.dart';
import 'package:chat_app/features/chat/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final sharedPreferences = await SharedPreferences.getInstance();
  final sharedPreferencesHelper = SharedPreferencesHelper(sharedPreferences);

  final authRemoteDataSource = AuthRemoteDataSourceImpl(FirebaseAuth.instance);
  final authLocalDataSource = AuthLocalDataSourceImpl(sharedPreferencesHelper);
  final userRepository = UserRepositoryImpl(
    authRemoteDataSource,
    authLocalDataSource,
    FirebaseFirestore.instance,
    FirebaseStorage.instance,
  );

  final signInWithPhoneNumberUseCase =
      SignInWithPhoneNumberUseCase(userRepository);
  final verifyCodeUseCases = VerifyCodeUseCases(userRepository);
  final saveProfileUseCase = SaveProfileUseCase(userRepository);

  final chatLocalDataSource = ChatLocalDataSourceImpl(sharedPreferencesHelper);
  final chatRemoteDataSource = ChatRemoteDataSourceImpl();
  final chatRepository = ChatRepositoryImpl(
    remoteDataSource: chatRemoteDataSource,
    localDataSource: chatLocalDataSource,
  );
  final getChatsUseCase = GetChatsUseCase(chatRepository);

  runApp(
    MyApp(
      signInWithPhoneNumberUseCase: signInWithPhoneNumberUseCase,
      verifyCodeUseCases: verifyCodeUseCases,
      saveProfileUseCase: saveProfileUseCase,
      getChatsUseCase: getChatsUseCase,
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({
    super.key,
    required this.signInWithPhoneNumberUseCase,
    required this.verifyCodeUseCases,
    required this.saveProfileUseCase,
    required this.getChatsUseCase,
  });

  final SignInWithPhoneNumberUseCase signInWithPhoneNumberUseCase;
  final VerifyCodeUseCases verifyCodeUseCases;
  final SaveProfileUseCase saveProfileUseCase;
  final GetChatsUseCase getChatsUseCase;

  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            signInWithPhoneNumber: signInWithPhoneNumberUseCase,
            verifyCode: verifyCodeUseCases,
          ),
        ),
        BlocProvider(
          create: (_) => ProfileBloc(saveProfileUseCase: saveProfileUseCase),
        ),
        BlocProvider(
          create: (_) =>
              ChatBloc(getChatsUseCase: getChatsUseCase)..add(LoadChatsEvent()),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: _appRouter.router,
        title: 'Chat App',
      ),
    );
  }
}
