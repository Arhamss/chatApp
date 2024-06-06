import 'package:chat_app/core/di/di.dart';
import 'package:chat_app/core/router/app_router.dart';
import 'package:chat_app/core/shared_preferences_helper.dart';
import 'package:chat_app/core/theme.dart';
import 'package:chat_app/core/theme_bloc/theme_bloc.dart';
import 'package:chat_app/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:chat_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:chat_app/features/auth/data/repositories/user_repository_impl.dart';
import 'package:chat_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:chat_app/features/chat/domain/use_cases/get_chats_use_case.dart';
import 'package:chat_app/features/chat/domain/use_cases/get_user_by_id_use_case.dart';
import 'package:chat_app/features/chat/presentation/bloc/bottom_nav_bar_bloc/bottom_nav_bar_bloc.dart';
import 'package:chat_app/features/chat/presentation/bloc/chat_home_bloc/chat_home_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    final sharedPreferencesHelper = GetIt.instance<SharedPreferencesHelper>();
    final firebaseAuth = GetIt.instance<FirebaseAuth>();
    final firebaseFirestore = GetIt.instance<FirebaseFirestore>();
    final firebaseStorage = GetIt.instance<FirebaseStorage>();

    //Auth Repository
    final authRemoteDataSource = AuthRemoteDataSource(
      firebaseAuth,
      firebaseFirestore,
    );
    final authLocalDataSource = AuthLocalDataSource(sharedPreferencesHelper);

    final userRepository = UserRepositoryImpl(
      authRemoteDataSource,
      authLocalDataSource,
      firebaseFirestore,
      firebaseStorage,
    );

    final getChatsUseCase =
        GetChatsUseCase(GetIt.instance<ChatRepositoryImpl>());
    final getUserByIdUseCase = GetUserByIdUseCase(userRepository);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BottomNavBarBloc()),
        BlocProvider(
          create: (context) => ChatHomeBloc(
            getChatsUseCase: getChatsUseCase,
            getUserByIdUseCase: getUserByIdUseCase,
          )..add(
              LoadChatsEvent(
                firebaseAuth.currentUser!.uid,
              ),
            ),
        ),
        BlocProvider(
          create: (context) => ThemeBloc(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          ThemeData themeData;
          if (state is ThemeInitial) {
            themeData = state.themeData;
          } else if (state is ThemeChanged) {
            themeData = state.themeData;
          } else {
            themeData = ThemeData.light();
          }
          return MaterialApp.router(
            theme: themeData,
            darkTheme: AppThemes().darkTheme,
            themeMode: themeData.brightness == Brightness.dark
                ? ThemeMode.dark
                : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            routerConfig: _appRouter.router,
            title: 'Chat App',
          );
        },
      ),
    );
  }
}
