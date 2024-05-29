import 'package:chat_app/core/router/app_router.dart';
import 'package:chat_app/core/shared_preferences_helper.dart';
import 'package:chat_app/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:chat_app/features/auth/data/data_sources/auth_remote_data_source_impl.dart';
import 'package:chat_app/features/auth/data/repositories/user_repository_impl.dart';
import 'package:chat_app/features/auth/domain/repositories/user_repository.dart';
import 'package:chat_app/features/auth/domain/use_cases/auth_use_cases.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:chat_app/features/auth/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final firebaseAuth = FirebaseAuth.instance;
  final remoteDataSource = AuthRemoteDataSourceImpl(firebaseAuth);
  final sharedPreferencesHelper = SharedPreferencesHelper();
  await sharedPreferencesHelper.init();

  final localDataSource = AuthLocalDataSourceImpl(sharedPreferencesHelper);
  final userRepository = UserRepositoryImpl(remoteDataSource, localDataSource);

  runApp(MyApp(userRepository: userRepository));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.userRepository});

  final UserRepository userRepository;
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            signInWithPhoneNumber: SignInWithPhoneNumberUseCase(userRepository),
            verifyCode: VerifyCodeUseCases(userRepository),
          ),
        ),
        BlocProvider(
          create: (_) => ProfileBloc(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: _appRouter.router,
        // theme: ThemeData.from(
        //     colorScheme: ColorScheme.fromSeed(seedColor: seedColor)),
        title: 'Chat App',
      ),
    );
  }
}
