import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._firebaseAuth, this.firestore);

  final FirebaseFirestore firestore;
  final FirebaseAuth _firebaseAuth;
  final Logger logger = Logger('AuthRemoteDataSource');

  Future<void> verifyPhoneNumber(
    String phoneNumber,
    void Function(PhoneAuthCredential) verificationCompleted,
    void Function(FirebaseAuthException) verificationFailed,
    void Function(String, int?) codeSent,
    void Function(String) codeAutoRetrievalTimeout,
  ) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (e, stackTrace) {
      logger.severe(
        'Failed to verify phone number: $phoneNumber',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  Future<UserCredential> signInWithCredential(
    PhoneAuthCredential credential,
  ) async {
    try {
      return await _firebaseAuth.signInWithCredential(credential);
    } catch (e, stackTrace) {
      logger.severe('Failed to sign in with credential', e, stackTrace);
      rethrow;
    }
  }

  Future<UserModel?> getUserDetails(String userId) async {
    try {
      final DocumentSnapshot userDoc =
          await firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        return UserModel.fromJson(userDoc.data()! as Map<String, dynamic>);
      } else {
        logger.info('User not found: $userId');
        return null;
      }
    } catch (e, stackTrace) {
      logger.severe(
        'Failed to fetch user details for user: $userId',
        e,
        stackTrace,
      );
      return null;
    }
  }

  Future<void> signOutUser() async {
    try{
    await FirebaseAuth.instance.signOut();
    }catch (e, stackTrace) {
      logger.severe(
        'Failed to log out',
        e,
        stackTrace,
      );
    }
  }

  String _sanitizeTopicName(String topic) {
    // Replace +92 with 0
    String sanitizedTopic = topic.replaceFirst('+92', '0');
    // Replace any invalid characters with an underscore
    return sanitizedTopic.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
  }

  void subscribeTopic(String topic){
    try{
    final messaging = GetIt.instance<FirebaseMessaging>();
    final phoneNumber = _sanitizeTopicName(topic);
    messaging.subscribeToTopic(phoneNumber);
    print("User subscribed to ${phoneNumber}");
    }catch (e, stackTrace) {
      logger.severe(
        'Failed to log out',
        e,
        stackTrace,
      );
    }
  }

  void unSubscribeTopic(String topic){
    try{
    final messaging = GetIt.instance<FirebaseMessaging>();
    final phoneNumber = _sanitizeTopicName(topic);
    messaging.unsubscribeFromTopic(phoneNumber);
    print("User unsubscribed to ${phoneNumber}");
    }catch (e, stackTrace) {
      logger.severe(
        'Failed to log out',
        e,
        stackTrace,
      );
    }
  }

  
}
