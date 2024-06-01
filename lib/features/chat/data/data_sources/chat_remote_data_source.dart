import 'package:chat_app/features/chat/data/models/conversation_model.dart';
import 'package:chat_app/features/chat/data/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

class ChatRemoteDataSource {
  ChatRemoteDataSource(this.firestore);

  final FirebaseFirestore firestore;
  final Logger logger = Logger('ChatRemoteDataSource');

  Future<List<ConversationModel>> getChats(String userId) async {
    try {
      final QuerySnapshot querySnapshot = await firestore
          .collection('conversations')
          .where('participants', arrayContains: userId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        logger.info('No conversations found for user $userId');
        return [];
      }

      return querySnapshot.docs
          .map(
            (doc) =>
                ConversationModel.fromJson(doc.data()! as Map<String, dynamic>),
          )
          .toList();
    } catch (e, s) {
      logger.severe('Failed to get conversations for user $userId', e, s);
      return [];
    }
  }

  Future<void> createChat(
    List<String> participantIds,
    String message,
    String senderId,
  ) async {
    try {
      final conversation = ConversationModel(
        id: '',
        participants: participantIds,
        lastMessage: message,
        lastMessageTime: DateTime.now(),
        lastMessageSender: senderId,
      );

      final DocumentReference conversationRef = await firestore
          .collection('conversations')
          .add(conversation.toJson());

      final messageModel = MessageModel(
        id: '',
        senderId: senderId,
        text: message,
        timestamp: DateTime.now(),
        type: 'text',
      );
      await conversationRef.collection('messages').add(messageModel.toJson());
    } catch (e, stackTrace) {
      logger.severe(
        'Failed to create conversation for participants $participantIds',
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
}
