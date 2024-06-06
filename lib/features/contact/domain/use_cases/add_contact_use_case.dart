import 'package:chat_app/core/failures.dart';
import 'package:chat_app/features/contact/domain/repositories/contact_repository.dart';
import 'package:dartz/dartz.dart';

class AddContactUseCase {
  AddContactUseCase(this.repository);

  final ContactRepository repository;

  Future<Either<Failure, void>> call(
    String userId,
    String contactUserid,
    String name,
    String phone,
    String photoUrl,
  ) async {
    return await repository.addContact(
      userId,
      contactUserid,
      name,
      phone,
      photoUrl,
    );
  }
}
