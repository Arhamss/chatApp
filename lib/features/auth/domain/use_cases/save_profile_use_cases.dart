import 'package:chat_app/core/failures.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:chat_app/features/auth/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

class SaveProfileUseCase {
  SaveProfileUseCase(this.repository);

  final UserRepository repository;

  Future<Either<Failure, Unit>> call(UserModel user) async {
    return await repository.saveUserProfile(user);
  }

  Future<Either<Failure, String>> uploadPhoto(String filePath) async {
    return await repository.uploadProfilePhoto(filePath);
  }
}
