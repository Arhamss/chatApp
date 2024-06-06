import 'package:chat_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logging/logging.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._firebaseAuth, this.firestore);

  final FirebaseFirestore firestore;
  final FirebaseAuth _firebaseAuth;
  final Logger logger = Logger('AuthRemoteDataSource');

  @override
  Future<void> verifyPhoneNumber(
    String phoneNumber,
    Function(PhoneAuthCredential) verificationCompleted,
    Function(FirebaseAuthException) verificationFailed,
    Function(String, int?) codeSent,
    Function(String) codeAutoRetrievalTimeout,
  ) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  @override
  Future<UserCredential> signInWithCredential(PhoneAuthCredential credential) {
    return _firebaseAuth.signInWithCredential(credential);
  }

  @override
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
}
