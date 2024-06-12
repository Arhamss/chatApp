part of 'contact_bloc.dart';

abstract class ContactState extends Equatable {
  const ContactState();

  @override
  List<Object> get props => [];
}

class ContactLoading extends ContactState {}

class ContactLoaded extends ContactState {
  const ContactLoaded(this.contacts);

  final List<ContactEntity> contacts;

  @override
  List<Object> get props => [contacts];
}

class ContactError extends ContactState {
  const ContactError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class NavigatingToChatScreen extends ContactState {
  const NavigatingToChatScreen(this.conversationId, this.receieverId);

  final String conversationId;
  final String receieverId;

  @override
  List<Object> get props => [
        conversationId,
        receieverId,
      ];
}
