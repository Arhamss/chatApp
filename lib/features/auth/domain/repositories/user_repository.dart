import 'package:chat_app/core/failures.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class UserRepository {
  Future<Either<Failure, Unit>> signInWithPhoneNumber(String phoneNumber);

  Future<Either<Failure, UserCredential>> verifyCode(String code);

  Future<Either<Failure, Unit>> saveUserProfile(UserModel user);

  Future<Either<Failure, String>> uploadProfilePhoto(String filePath);
}
