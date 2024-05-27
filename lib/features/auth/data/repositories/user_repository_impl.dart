import 'package:chat_app/core/failures.dart';
import 'package:chat_app/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:chat_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:chat_app/features/auth/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this.remoteDataSource, this.localDataSource);
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  @override
  Future<Either<Failure, Unit>> signInWithPhoneNumber(
    String phoneNumber,
  ) async {
    try {
      await remoteDataSource.verifyPhoneNumber(
        phoneNumber,
        (PhoneAuthCredential credential) async {
          await remoteDataSource.signInWithCredential(credential);
        },
        (FirebaseAuthException e) {
          print(e);
          throw ServerFailure();
        },
        (String verificationId, int? resendToken) async {
          await localDataSource.cacheVerificationId(verificationId);
        },
        (String verificationId) async {
          await localDataSource.cacheVerificationId(verificationId);
        },
      );
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, UserCredential>> verifyCode(String code) async {
    try {
      final verificationId = localDataSource.getVerificationId();
      if (verificationId == null) {
        return Left(ServerFailure());
      }

      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: code,
      );
      final userCredential =
          await remoteDataSource.signInWithCredential(credential);
      return Right(userCredential);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
