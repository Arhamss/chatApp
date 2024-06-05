import 'package:chat_app/core/shared_preferences_helper.dart';
import 'package:chat_app/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:chat_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:chat_app/features/auth/data/repositories/user_repository_impl.dart';
import 'package:chat_app/features/auth/domain/use_cases/save_profile_use_cases.dart';
import 'package:chat_app/features/auth/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:chat_app/features/auth/presentation/views/profile_setup_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ProfileSetupPage extends StatelessWidget {
  const ProfileSetupPage({super.key});

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

    //UseCases
    final saveProfileUseCase = SaveProfileUseCase(userRepository);

    return BlocProvider(
      create: (context) => ProfileBloc(
        saveProfileUseCase: saveProfileUseCase,
      ),
      child: ProfileSetupView(),
    );
  }
}
