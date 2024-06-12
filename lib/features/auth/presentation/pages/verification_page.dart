import 'package:chat_app/core/shared_preferences_helper.dart';
import 'package:chat_app/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:chat_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:chat_app/features/auth/data/repositories/user_repository_impl.dart';
import 'package:chat_app/features/auth/domain/use_cases/auth_use_cases.dart';
import 'package:chat_app/features/auth/domain/use_cases/get_user_by_id_use_case.dart';
import 'package:chat_app/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:chat_app/features/auth/presentation/views/verfication_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class VerificationPage extends StatelessWidget {
  const VerificationPage({super.key, required this.verificationId});

  final String verificationId;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRemoteDataSource>(
          create: (context) => AuthRemoteDataSource(
            GetIt.instance<FirebaseAuth>(),
            GetIt.instance<FirebaseFirestore>(),
          ),
        ),
        RepositoryProvider<AuthLocalDataSource>(
          create: (context) =>
              AuthLocalDataSource(GetIt.instance<SharedPreferencesHelper>()),
        ),
        RepositoryProvider<UserRepositoryImpl>(
          create: (context) => UserRepositoryImpl(
            RepositoryProvider.of<AuthRemoteDataSource>(context),
            RepositoryProvider.of<AuthLocalDataSource>(context),
            GetIt.instance<FirebaseFirestore>(),
            GetIt.instance<FirebaseStorage>(),
          ),
        ),
        RepositoryProvider<SignInWithPhoneNumberUseCase>(
          create: (context) => SignInWithPhoneNumberUseCase(
            RepositoryProvider.of<UserRepositoryImpl>(context),
          ),
        ),
        RepositoryProvider<VerifyCodeUseCases>(
          create: (context) => VerifyCodeUseCases(
            RepositoryProvider.of<UserRepositoryImpl>(context),
          ),
        ),
        RepositoryProvider<GetUserByIdUseCase>(
          create: (context) => GetUserByIdUseCase(
            RepositoryProvider.of<UserRepositoryImpl>(context),
          ),
        ),
        RepositoryProvider<NotificationUseCases>(
          create: (context) => NotificationUseCases(
            repository: 
            RepositoryProvider.of<UserRepositoryImpl>(context),
          ),
        ),
        RepositoryProvider<AuthUseCases>(
          create: (context) => AuthUseCases(
            repository: 
            RepositoryProvider.of<UserRepositoryImpl>(context),
          ),
        ),
      ],
      child: BlocProvider(
        create: (context) => AuthBloc(
          signInWithPhoneNumber:
              RepositoryProvider.of<SignInWithPhoneNumberUseCase>(context),
          verifyCode: RepositoryProvider.of<VerifyCodeUseCases>(context),
          getUserByIdUseCase:
              RepositoryProvider.of<GetUserByIdUseCase>(context),
              notificationUseCases: RepositoryProvider.of<NotificationUseCases>(context),
              authUseCases: RepositoryProvider.of<AuthUseCases>(context),
        ),
        child: VerificationView(verificationId: verificationId),
      
      ),
    );
  }
}
