import 'package:chat_app/AppConfig.dart';
import 'package:chat_app/core/router/app_router.dart';
import 'package:chat_app/core/shared_preferences_helper.dart';
import 'package:chat_app/core/theme.dart';
import 'package:chat_app/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:chat_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:chat_app/features/auth/data/repositories/user_repository_impl.dart';
import 'package:chat_app/features/auth/domain/use_cases/auth_use_cases.dart';
import 'package:chat_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:chat_app/features/chat/domain/use_cases/get_chats_use_case.dart';
import 'package:chat_app/features/chat/domain/use_cases/get_user_by_id_use_case.dart';
import 'package:chat_app/features/chat/presentation/bloc/bottom_nav_bar_bloc/bottom_nav_bar_bloc.dart';
import 'package:chat_app/features/chat/presentation/bloc/chat_home_bloc/chat_home_bloc.dart';
import 'package:chat_app/features/locale/bloc/locale_bloc.dart';
import 'package:chat_app/features/more/presentation/bloc/theme_bloc/theme_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';

Future<void> runWithAppConfig(AppConfig appConfig) async {
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ur')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MyApp(
        appConfig: appConfig,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({required this.appConfig, super.key});

  final AppRouter _appRouter = AppRouter();
  final AppThemes appThemes = AppThemes();
  final AppConfig appConfig;

  @override
  Widget build(BuildContext context) {
    final sharedPreferencesHelper = GetIt.instance<SharedPreferencesHelper>();
    final firebaseAuth = GetIt.instance<FirebaseAuth>();
    final firebaseFirestore = GetIt.instance<FirebaseFirestore>();
    final firebaseStorage = GetIt.instance<FirebaseStorage>();

    // Auth Repository
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

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print(
          'Message also contained a notification: ${message.notification!.body}',
        );

        final messageRes =
            '${message.notification!.title}\n${message.notification!.body}';

        Fluttertoast.showToast(
          msg: messageRes,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 2, 249, 15),
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    });

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => VerifyCodeUseCases(
            RepositoryProvider.of<UserRepositoryImpl>(context),
          ),
        ),
      ],
      child: MultiBlocProvider(
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
          BlocProvider<ThemeBloc>(
            create: (context) => ThemeBloc(),
          ),
          BlocProvider<LocaleBloc>(
            create: (context) => LocaleBloc()..add(LoadDeviceLocaleEvent()),
          ),
        ],
        child: AppView(
          appThemes: appThemes,
          appRouter: _appRouter,
          appConfig: appConfig,
        ),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({
    super.key,
    required this.appThemes,
    required AppRouter appRouter,
    required this.appConfig,
  }) : _appRouter = appRouter;

  final AppThemes appThemes;
  final AppRouter _appRouter;
  final AppConfig appConfig;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      buildWhen: (previous, current) {
        return previous.themeMode != current.themeMode;
      },
      builder: (context, themeState) {
        return BlocBuilder<LocaleBloc, LocaleState>(
          builder: (context, localeState) {
            return MaterialApp.router(
              themeMode: themeState.themeMode,
              darkTheme: appThemes.darkTheme,
              theme: appThemes.lightTheme,
              debugShowCheckedModeBanner: false,
              routerConfig: _appRouter.router,
              title: appConfig.appName,
              locale: localeState is LocaleLoaded
                  ? localeState.locale
                  : context.locale,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
            );
          },
        );
      },
    );
  }
}
