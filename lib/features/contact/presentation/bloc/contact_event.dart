part of 'contact_bloc.dart';

abstract class ContactEvent extends Equatable {
  const ContactEvent(this.userId);

  final String userId;

  @override
  List<Object> get props => [
        userId,
      ];
}

class AddContactEvent extends ContactEvent {
  const AddContactEvent(
    super.userId, {
    required this.contactUserid,
    required this.name,
    required this.phone,
    required this.photoUrl,
  });

  final String contactUserid;
  final String name;
  final String phone;
  final String photoUrl;

  @override
  List<Object> get props => [
        userId,
        contactUserid,
        name,
        phone,
        photoUrl,
      ];
}

class LoadContactEvent extends ContactEvent {
  const LoadContactEvent(
    super.userId,
  );
}

class NavigateToChatScreenEvent extends ContactEvent {
  const NavigateToChatScreenEvent(
    super.userId, {
    required this.contactId,
    required this.contacts,
  });

  final String contactId;
  final List<ContactEntity> contacts;

  @override
  List<Object> get props => super.props..add(contactId);
}
