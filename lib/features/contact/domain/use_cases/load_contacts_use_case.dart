import 'package:chat_app/core/failures.dart';
import 'package:chat_app/features/contact/domain/entities/contact_entity.dart';
import 'package:chat_app/features/contact/domain/repositories/contact_repository.dart';
import 'package:dartz/dartz.dart';

class LoadContactsUseCase {
  LoadContactsUseCase(this.repository);

  final ContactRepository repository;

  Future<Either<Failure, List<ContactEntity>>> call(
    String userId,
  ) async {
    return await repository.loadContacts(
      userId,
    );
  }
}
