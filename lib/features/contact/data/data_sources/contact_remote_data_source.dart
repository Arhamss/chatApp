import 'package:chat_app/features/contact/data/models/contact_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

class ContactRemoteDataSource {
  ContactRemoteDataSource(this.firestore);

  final FirebaseFirestore firestore;
  final Logger logger = Logger('ContactRemoteDataSource');

  Future<void> addContact(
    String userId,
    String contactUserid,
    String name,
    String phone,
    String photoUrl,
  ) async {
    try {
      final contact = ContactModel(
        id: '',
        contactUserId: contactUserid,
        name: name,
        phone: phone,
        photoUrl: photoUrl,
      );
      await firestore
          .collection('users')
          .doc(userId)
          .collection('contacts')
          .doc(contact.id)
          .set(contact.toJson());
    } catch (e, stackTrace) {
      logger.severe('Failed to add contact for user $userId', e, stackTrace);
      rethrow;
    }
  }

  Future<List<ContactModel>> loadContacts(String userId) async {
    try {
      final QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('contacts')
          .get();
      return querySnapshot.docs
          .map(
            (doc) => ContactModel.fromJson(doc.data()! as Map<String, dynamic>),
          )
          .toList();
    } catch (e, stackTrace) {
      logger.severe('Failed to load contacts for user $userId', e, stackTrace);
      rethrow;
    }
  }
}
