import 'dart:convert';
import 'package:chat_app/core/failures.dart';
import 'package:chat_app/features/contact/data/data_sources/contact_local_data_source.dart';
import 'package:chat_app/features/contact/data/data_sources/contact_remote_data_source.dart';
import 'package:chat_app/features/contact/data/models/contact_model.dart';
import 'package:chat_app/features/contact/domain/entities/contact_entity.dart';
import 'package:chat_app/features/contact/domain/repositories/contact_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:logging/logging.dart';

class ContactRepositoryImpl implements ContactRepository {
  ContactRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final ContactRemoteDataSource remoteDataSource;
  final ContactLocalDataSource localDataSource;
  final Logger logger = Logger('ContactRepositoryImpl');

  @override
  Future<Either<Failure, List<ContactEntity>>> loadContacts(
    String userId,
  ) async {
    try {
      final remoteContacts = await remoteDataSource.loadContacts(userId);
      localDataSource.cacheContacts(
        remoteContacts.map((contact) => jsonEncode(contact.toJson())).toList(),
      );
      return Right(remoteContacts);
    } catch (e, stackTrace) {
      logger.severe('Failed to load contacts for user $userId', e, stackTrace);
      final cachedContacts = localDataSource.getCachedContacts();
      if (cachedContacts != null) {
        final contacts = cachedContacts
            .map(
              (contact) => ContactModel.fromJson(
                jsonDecode(contact) as Map<String, dynamic>,
              ),
            )
            .toList();
        return Right(contacts);
      }
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addContact(
    String userId,
    String contactUserid,
    String name,
    String phone,
    String photoUrl,
  ) async {
    try {
      await remoteDataSource.addContact(
        userId,
        contactUserid,
        name,
        phone,
        photoUrl,
      );
      return const Right(null);
    } catch (e, stackTrace) {
      logger.severe('Failed to add contact for user $userId', e, stackTrace);
      return Left(ServerFailure());
    }
  }
}
