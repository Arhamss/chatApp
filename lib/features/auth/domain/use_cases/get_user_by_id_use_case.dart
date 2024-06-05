import 'package:chat_app/core/failures.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:chat_app/features/auth/domain/repositories/user_repository.dart';

import 'package:dartz/dartz.dart';

class GetUserByIdUseCase {
  GetUserByIdUseCase(this.repository);

  final UserRepository repository;

  Future<Either<Failure, UserModel>> call(
    String userId,
  ) {
    return repository.getUserDetails(
      userId,
    );
  }
}
