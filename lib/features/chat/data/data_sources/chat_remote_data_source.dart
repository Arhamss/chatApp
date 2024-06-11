import 'package:chat_app/features/chat/data/models/conversation_model.dart';
import 'package:chat_app/features/chat/data/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

class ChatRemoteDataSource {
  ChatRemoteDataSource(this.firestore);

  final FirebaseFirestore firestore;
  final Logger logger = Logger('ChatRemoteDataSource');

  Stream<List<ConversationModel>> getChats(String userId) {
    return firestore
        .collection('conversations')
        .where('participants', arrayContains: userId)
        .orderBy(
          'lastMessageTime',
          descending: true,
        )
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return ConversationModel.fromJson(doc.data()! as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<void> sendMessage(
    String senderId,
    String text,
    String conversationId,
  ) async {
    try {
      final docRef = firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .doc();
      await firestore.runTransaction((transaction) async {
        transaction.set(docRef, {
          'id': docRef.id,
          'senderId': senderId,
          'text': text,
          'timestamp': FieldValue.serverTimestamp(),
          'type': 'text',
        });
        transaction
            .update(firestore.collection('conversations').doc(conversationId), {
          'lastMessage': text,
          'lastMessageTime': FieldValue.serverTimestamp(),
        });
      });
    } catch (e, stackTrace) {
      logger.severe(
        'Failed to send message in conversation: $conversationId',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  Future<String?> findConversation(String userId, String contactId) async {
    final querySnapshot = await firestore
        .collection('conversations')
        .where('participants', arrayContains: userId)
        .get();

    for (final doc in querySnapshot.docs) {
      final List<String> participants =
          List<String>.from(doc.data()['participants'] as List);
      if (participants.contains(contactId)) {
        return doc.id;
      }
    }
    return null;
  }

  Future<String> createConversation(List<String> participantIds) async {
    final docRef = firestore.collection('conversations').doc();

    await docRef.set({
      'id': docRef.id,
      'participants': participantIds,
      'lastMessage': '',
      'lastMessageTime': FieldValue.serverTimestamp(),
      'createdOn': FieldValue.serverTimestamp(),
      'lastMessageSender': participantIds[1],
    });

    return docRef.id;
  }

  Stream<List<MessageModel>> loadChatMessage(String conversationId) {
    return firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy(
          'timestamp',
          descending: true,
        )
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return MessageModel.fromJson(doc.data()! as Map<String, dynamic>);
      }).toList();
    });
  }
}
