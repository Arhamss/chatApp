import 'package:chat_app/core/shared_preferences_helper.dart';
import 'package:chat_app/features/chat/data/data_sources/chat_local_data_source.dart';
import 'package:chat_app/features/chat/data/data_sources/chat_remote_data_source.dart';
import 'package:chat_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:chat_app/features/contact/data/data_sources/contact_local_data_source.dart';
import 'package:chat_app/features/contact/data/data_sources/contact_remote_data_source.dart';
import 'package:chat_app/features/contact/data/repositories/contact_repository_impl.dart';
import 'package:chat_app/features/contact/domain/use_cases/add_contact_use_case.dart';
import 'package:chat_app/features/contact/domain/use_cases/load_contacts_use_case.dart';
import 'package:chat_app/features/contact/domain/use_cases/load_or_create_chat_conversation_use_case.dart';
import 'package:chat_app/features/contact/presentation/bloc/contact_bloc.dart';
import 'package:chat_app/features/contact/presentation/views/contacts_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sharedPreferencesHelper = GetIt.instance<SharedPreferencesHelper>();
    final fireBaseAuth = GetIt.instance<FirebaseAuth>();
    final firebaseFirestore = GetIt.instance<FirebaseFirestore>();

    //Contact Repository
    final contactLocalDataSource =
        ContactLocalDataSource(sharedPreferencesHelper);
    final contactRemoteDataSource = ContactRemoteDataSource(firebaseFirestore);

    final contactRepository = ContactRepositoryImpl(
      remoteDataSource: contactRemoteDataSource,
      localDataSource: contactLocalDataSource,
    );

    //Chat Repository
    final chatLocalDataSource = ChatLocalDataSource(sharedPreferencesHelper);
    final chatRemoteDataSource = ChatRemoteDataSource(firebaseFirestore);

    final chatRepository = ChatRepositoryImpl(
      remoteDataSource: chatRemoteDataSource,
      localDataSource: chatLocalDataSource,
    );

    //UseCases
    final addContactUseCase = AddContactUseCase(contactRepository);
    final loadContactsUseCase = LoadContactsUseCase(contactRepository);
    final loadOrCreateChatConversationUseCase =
        LoadOrCreateChatConversationUseCase(
      chatRepository,
    );

    return BlocProvider(
      create: (context) => ContactBloc(
        addContactUseCase: addContactUseCase,
        loadContactsUseCase: loadContactsUseCase,
        loadOrCreateChatConversationUseCase:
            loadOrCreateChatConversationUseCase,
      )..add(
          LoadContactEvent(
            fireBaseAuth.currentUser!.uid,
          ),
        ),
      child: ContactsView(),
    );
  }
}
