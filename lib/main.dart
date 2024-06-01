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
import 'package:chat_app/features/chat/domain/use_cases/create_chat_use_case.dart';
import 'package:chat_app/features/chat/domain/use_cases/get_chats_use_case.dart';
import 'package:chat_app/features/chat/presentation/bloc/bottom_nav_bar_bloc/bottom_nav_bar_bloc.dart';
import 'package:chat_app/features/chat/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:chat_app/features/contact/data/data_sources/contact_local_data_source.dart';
import 'package:chat_app/features/contact/data/data_sources/contact_remote_data_source.dart';
import 'package:chat_app/features/contact/data/repositories/contact_repository_impl.dart';
import 'package:chat_app/features/contact/domain/use_cases/add_contact_use_case.dart';
import 'package:chat_app/features/contact/domain/use_cases/load_contacts_use_case.dart';
import 'package:chat_app/features/contact/domain/use_cases/load_or_create_chat_conversation_use_case.dart';
import 'package:chat_app/features/contact/presentation/bloc/contact_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPreferencesHelper.init();
  final SharedPreferencesHelper sharedPreferencesHelper =
      SharedPreferencesHelper.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final authRemoteDataSource = AuthRemoteDataSourceImpl(FirebaseAuth.instance);
  final authLocalDataSource = AuthLocalDataSourceImpl(sharedPreferencesHelper);

  final userRepository = UserRepositoryImpl(
    authRemoteDataSource,
    authLocalDataSource,
    firebaseFirestore,
    FirebaseStorage.instance,
  );

  final signInWithPhoneNumberUseCase =
      SignInWithPhoneNumberUseCase(userRepository);
  final verifyCodeUseCases = VerifyCodeUseCases(userRepository);
  final saveProfileUseCase = SaveProfileUseCase(userRepository);

  final chatLocalDataSource = ChatLocalDataSource(sharedPreferencesHelper);
  final chatRemoteDataSource = ChatRemoteDataSource(firebaseFirestore);

  final chatRepository = ChatRepositoryImpl(
    remoteDataSource: chatRemoteDataSource,
    localDataSource: chatLocalDataSource,
  );
  final getChatsUseCase = GetChatsUseCase(chatRepository);
  final createChatsUseCase = CreateChatUseCase(chatRepository);

  final contactLocalDataSource =
      ContactLocalDataSource(sharedPreferencesHelper);
  final contactRemoteDataSource = ContactRemoteDataSource(firebaseFirestore);

  final contactRepository = ContactRepositoryImpl(
    remoteDataSource: contactRemoteDataSource,
    localDataSource: contactLocalDataSource,
  );
  final addContactUseCase = AddContactUseCase(contactRepository);
  final loadContactsUseCase = LoadContactsUseCase(contactRepository);
  final loadOrCreateChatConversationUseCase =
      LoadOrCreateChatConversationUseCase(chatRepository);

  runApp(
    MyApp(
      signInWithPhoneNumberUseCase: signInWithPhoneNumberUseCase,
      verifyCodeUseCases: verifyCodeUseCases,
      saveProfileUseCase: saveProfileUseCase,
      getChatsUseCase: getChatsUseCase,
      createChatUseCase: createChatsUseCase,
      firebaseAuth: firebaseAuth,
      addContactsUseCase: addContactUseCase,
      loadContactsUseCase: loadContactsUseCase,
      loadOrCreateChatConversationUseCase: loadOrCreateChatConversationUseCase,
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
    required this.createChatUseCase,
    required this.firebaseAuth,
    required this.addContactsUseCase,
    required this.loadContactsUseCase,
    required this.loadOrCreateChatConversationUseCase,
  });

  final SignInWithPhoneNumberUseCase signInWithPhoneNumberUseCase;
  final VerifyCodeUseCases verifyCodeUseCases;
  final SaveProfileUseCase saveProfileUseCase;
  final GetChatsUseCase getChatsUseCase;
  final CreateChatUseCase createChatUseCase;
  final FirebaseAuth firebaseAuth;
  final AddContactUseCase addContactsUseCase;
  final LoadContactsUseCase loadContactsUseCase;
  final LoadOrCreateChatConversationUseCase loadOrCreateChatConversationUseCase;

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
          create: (_) => ChatBloc(
            getChatsUseCase: getChatsUseCase,
            createChatUsecase: createChatUseCase,
          )..add(
              LoadChatsEvent(
                firebaseAuth.currentUser!.uid,
              ),
            ),
        ),
        BlocProvider(
          create: (_) => ContactBloc(
            addContactUseCase: addContactsUseCase,
            loadContactsUseCase: loadContactsUseCase,
            loadOrCreateChatConversationUseCase:
                loadOrCreateChatConversationUseCase,
          )..add(
              LoadContactEvent(
                firebaseAuth.currentUser!.uid,
              ),
            ),
        ),
        BlocProvider(
          create: (_) => BottomNavBarBloc(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: _appRouter.router,
        title: 'Chat App',
      ),
    );
  }
}
