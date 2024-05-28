import 'package:chat_app/core/shared_preferences_helper.dart';
import 'package:chat_app/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:chat_app/features/auth/data/data_sources/auth_remote_data_source_impl.dart';
import 'package:chat_app/features/auth/data/repositories/user_repository_impl.dart';
import 'package:chat_app/features/auth/domain/repositories/user_repository.dart';
import 'package:chat_app/features/auth/domain/use_cases/auth_use_cases.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:chat_app/features/auth/presentation/pages/landing_page.dart';
import 'package:chat_app/features/auth/presentation/pages/phone_number_page.dart';
import 'package:chat_app/features/auth/presentation/pages/verification_page.dart';
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
  const MyApp({super.key, required this.userRepository});

  final UserRepository userRepository;

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
      ],
      child: MaterialApp(
        title: 'Chat App',
        initialRoute: '/',
        routes: {
          '/': (context) => const LandingPage(),
          '/phone': (context) => PhoneNumberPage(),
          '/verify': (context) => VerificationPage(),
        },
      ),
    );
  }
}
