import 'package:chat_app/core/failures.dart';
import 'package:chat_app/features/contact/domain/entities/contact_entity.dart';

import 'package:dartz/dartz.dart';

abstract class ContactRepository {
  Future<Either<Failure, List<ContactEntity>>> loadContacts(
    String userId,
  );

  Future<Either<Failure, void>> addContact(
    String userId,
    String contactUserid,
    String name,
    String phone,
    String photoUrl,
  );
}
