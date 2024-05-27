import 'package:chat_app/core/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class UserRepository {
  Future<Either<Failure, Unit>> signInWithPhoneNumber(String phoneNumber);
  Future<Either<Failure, UserCredential>> verifyCode(String code);
}
