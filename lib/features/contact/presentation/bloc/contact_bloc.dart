import 'package:bloc/bloc.dart';
import 'package:chat_app/features/contact/domain/entities/contact_entity.dart';
import 'package:chat_app/features/contact/domain/use_cases/add_contact_use_case.dart';
import 'package:chat_app/features/contact/domain/use_cases/load_contacts_use_case.dart';
import 'package:chat_app/features/contact/domain/use_cases/load_or_create_chat_conversation_use_case.dart';
import 'package:equatable/equatable.dart';

part 'contact_event.dart';

part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  ContactBloc({
    required this.addContactUseCase,
    required this.loadContactsUseCase,
    required this.loadOrCreateChatConversationUseCase,
  }) : super(ContactLoading()) {
    on<LoadContactEvent>(_onLoadContacts);
    on<AddContactEvent>(_onAddContact);
    on<NavigateToChatScreenEvent>(_onNavigateToChatScreenEvent);
  }

  AddContactUseCase addContactUseCase;
  LoadContactsUseCase loadContactsUseCase;
  LoadOrCreateChatConversationUseCase loadOrCreateChatConversationUseCase;

  Future<void> _onAddContact(
    AddContactEvent event,
    Emitter<ContactState> emit,
  ) async {
    emit(ContactLoading());

    final result = await addContactUseCase.call(
      event.userId,
      event.contactUserid,
      event.name,
      event.phone,
      event.photoUrl,
    );
    result.fold(
      (failure) => emit(ContactError(failure.toString())),
      (_) => null,
    );
    final contacts = await loadContactsUseCase.call(event.userId);
    contacts.fold(
      (failure) => emit(ContactError(failure.toString())),
      (contacts) => emit(ContactLoaded(contacts)),
    );
  }

  Future<void> _onLoadContacts(
    LoadContactEvent event,
    Emitter<ContactState> emit,
  ) async {
    emit(ContactLoading());

    final result = await loadContactsUseCase.call(event.userId);
    result.fold(
      (failure) => emit(ContactError(failure.toString())),
      (contacts) => emit(ContactLoaded(contacts)),
    );
  }

  Future<void> _onNavigateToChatScreenEvent(
    NavigateToChatScreenEvent event,
    Emitter<ContactState> emit,
  ) async {
    String contactUserId = '';
    for (int i = 0; i < event.contacts.length; i++) {
      if (event.contactId == event.contacts[i].id) {
        contactUserId = event.contacts[i].contactUserId;
      }
    }

    final result = await loadOrCreateChatConversationUseCase.call(
      event.userId,
      contactUserId,
    );

    result.fold(
      (failure) => emit(ContactError(failure.toString())),
      (conversationId) => emit(
        NavigatingToChatScreen(
          conversationId,
          contactUserId,
        ),
      ),
    );

    emit(ContactLoaded(event.contacts));
  }
}
