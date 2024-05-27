import 'package:chat_app/core/failures.dart';
import 'package:chat_app/features/auth/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInWithPhoneNumber {
  SignInWithPhoneNumber(this.repository);
  final UserRepository repository;

  Future<Either<Failure, Unit>> call(String phoneNumber) {
    return repository.signInWithPhoneNumber(phoneNumber);
  }
}

class VerifyCode {
  VerifyCode(this.repository);
  final UserRepository repository;

  Future<Either<Failure, UserCredential>> call(String code) {
    return repository.verifyCode(code);
  }
}
