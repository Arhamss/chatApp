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
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ContactLocalDataSource>(
          create: (context) =>
              ContactLocalDataSource(GetIt.instance<SharedPreferencesHelper>()),
        ),
        RepositoryProvider<ContactRemoteDataSource>(
          create: (context) =>
              ContactRemoteDataSource(GetIt.instance<FirebaseFirestore>()),
        ),
        RepositoryProvider<ContactRepositoryImpl>(
          create: (context) => ContactRepositoryImpl(
            remoteDataSource:
                RepositoryProvider.of<ContactRemoteDataSource>(context),
            localDataSource:
                RepositoryProvider.of<ContactLocalDataSource>(context),
          ),
        ),
        RepositoryProvider<ChatLocalDataSource>(
          create: (context) =>
              ChatLocalDataSource(GetIt.instance<SharedPreferencesHelper>()),
        ),
        RepositoryProvider<ChatRemoteDataSource>(
          create: (context) =>
              ChatRemoteDataSource(GetIt.instance<FirebaseFirestore>()),
        ),
        RepositoryProvider<ChatRepositoryImpl>(
          create: (context) => ChatRepositoryImpl(
            remoteDataSource:
                RepositoryProvider.of<ChatRemoteDataSource>(context),
            localDataSource:
                RepositoryProvider.of<ChatLocalDataSource>(context),
          ),
        ),
        RepositoryProvider<AddContactUseCase>(
          create: (context) => AddContactUseCase(
            RepositoryProvider.of<ContactRepositoryImpl>(context),
          ),
        ),
        RepositoryProvider<LoadContactsUseCase>(
          create: (context) => LoadContactsUseCase(
            RepositoryProvider.of<ContactRepositoryImpl>(context),
          ),
        ),
        RepositoryProvider<LoadOrCreateChatConversationUseCase>(
          create: (context) => LoadOrCreateChatConversationUseCase(
            RepositoryProvider.of<ChatRepositoryImpl>(context),
          ),
        ),
      ],
      child: BlocProvider(
        create: (context) => ContactBloc(
          addContactUseCase: RepositoryProvider.of<AddContactUseCase>(context),
          loadContactsUseCase:
              RepositoryProvider.of<LoadContactsUseCase>(context),
          loadOrCreateChatConversationUseCase:
              RepositoryProvider.of<LoadOrCreateChatConversationUseCase>(
            context,
          ),
        )..add(
            LoadContactEvent(
              GetIt.instance<FirebaseAuth>().currentUser!.uid,
            ),
          ),
        child: ContactsView(),
      ),
    );
  }
}
