import 'dart:convert';
import 'dart:io';

import 'package:chat_app/features/chat/data/models/conversation_model.dart';
import 'package:chat_app/features/chat/data/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get_it/get_it.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';

class ChatRemoteDataSource {
  ChatRemoteDataSource(this.firestore, this.storage);

  final FirebaseFirestore firestore;
  final FirebaseStorage storage;
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




  // final String serverToken = 'ya29.c.c0AY_VpZirho_MVgCWT6ujUwwy07QCnp8oZhOOKfPdkcU06yJMG1pt-ojDZiQUOrqLW43tfhpign_AlPeGIFwhldikhbJSzYUlfNL-czgvOWKqTG6uWGJOV0M409ks6KBZPrAPX0Ysf_hsZya-2pCs6hiSbgnOhPZaLHtFvIgcWFvJtRFtHb9_l85A2AyHhVHYJTJDDGa35Mfk53EaYBy0WRwLMzZeb5ftq062UHJrqtY0BM0pCmfZ2aAO3qEPimHIbOnwdDg2UsWxjzjlOvWmeRw_Lxwii_WAoAZwaQaGgVg2tB8uE80AR4ISspwnXRgxMN7SEb-4sZZ6ccWeRPgI4d77HEHBozBOkfZVguPP8njE6AKjzcwYNShIH385KqSsMm38kM10s_abF05IVZZkBJvBo-8Wj4F0m3_p_M_na9WenUySp2Q3kekhe1s-3Jvarnywderb5IMlqxFRh-bB58wZvMWzJviO71WW8ikorU6O8f9WfY9M7xp-08p_rrh54aImOwt4bUqUZt7nobc3SqeRbVmerRcRjcmbweOc97diRr_2fgY3Oj-lwysMyauXtS17pJryk1I5Uj-ohqfuwUIU8uW_jO7rsQX9vkjO8h08Vd-WIISuxFnBqFiwtybYJat2Yn_2otqQy04vJV_g4qjbxm-vheYn15tmaSjuJbg67bB97Y_i7sgss6fr2z0dh1w9fBuQnhmB3Rgy-IpqVSb7y686Yg6o4UJSdQkBw68czejmpXSUf_UyyFq3V1ZmFgf9zWgXqnx0IgQseOx0_vhZMv69byZ9q2f_k4IqBnc_czFQtOFegFpt47yM1ou5X_jo9Y9e_dzjq1aislt8kmhR4u_mdhR8X9rpr-X8jo4Vz5YoMtj7vZwfQ5vOe6yuuVs640dJ2Wsx59QVmYt8-117J_hrxIi5_h4oSFyivu2oU7ZekQ2V7pt2B1-839Rjz7o8j8jRq--RJg8RfUm0FhOzV9YyVR8d0jvxQ8fficpMrb9OpkoBl4o'; // Replace with your actual server key
  final String fcmUrl = 'https://fcm.googleapis.com/v1/projects/chatapp-2a7b8/messages:send';
  final List<String> scopes = [
        'https://www.googleapis.com/auth/cloud-platform',
      'https://www.googleapis.com/auth/firebase.messaging',
      ];

   Future<auth.AccessToken> _getAccessToken() async {
    final serviceAccountKey = await rootBundle.loadString('assets/jsons/google-service-auth.json');
    final accountCredentials = auth.ServiceAccountCredentials.fromJson(serviceAccountKey);
    final authClient = await auth.clientViaServiceAccount(accountCredentials, scopes);
    return authClient.credentials.accessToken;
  }

  Future<void> _sendPushNotification({
    required String topic,
    required String title,
    required String body,
  }) async {
    try {
      final serverToken = await _getAccessToken();
      final response = await http.post(
        Uri.parse(fcmUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${serverToken.data}',
        },
        body: jsonEncode({
          "message": {
            "topic": topic,
            "notification": {
              "title": title,
              "body": body,
            },
          },
        }),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully to topic ${topic}');
        
      } else {
        print('Failed to send notification: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Error in sending Notificaiton with statuc code ${response.statusCode} and body ${response.body}');
      }
    } catch (e) {
      print('Error sending notification: $e');
      throw Exception('Error sending notification: $e');
    }
  }


  Future<void> uploadVideoToFirebase(XFile file, bool isVideo) async {
  try {
    print("Remote Data source par bhi pocha hia");
    // Create a reference to Firebase Storage
    Reference storageRef;
    if(isVideo){
    storageRef = storage.ref().child('videos/${file.name}');
    }
    else{
      storageRef = storage.ref().child('images/${file.name}');
    }

    // Upload the file
    UploadTask uploadTask = storageRef.putFile(File(file.path));

    // Wait for the upload to complete
    TaskSnapshot taskSnapshot = await uploadTask;

    // Get the download URL
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    // Use the download URL as needed
    print('Download URL: $downloadUrl');
  } catch (e) {
    // Handle errors
    print('Error uploading video: $e');
  }
}


  Future<String> getCurrentUserId() async {
    try{
      final firebaseAuth = GetIt.instance<FirebaseAuth>();
      return firebaseAuth.currentUser!.uid;
    }catch (e) {
      print('Error getting current user: $e');
      throw Exception('Error getting current user: $e');
    }
  }


  Future<void> sendMessage(
    String senderId,
    String text,
    String topicForNotification,
    String currentUserName,
    String conversationId,
  ) async {
    try {
      await _sendPushNotification(topic: topicForNotification, title: currentUserName,body: text );
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
