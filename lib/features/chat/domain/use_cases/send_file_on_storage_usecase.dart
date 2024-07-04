import 'package:chat_app/core/failures.dart';
import 'package:chat_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

class SendFileOnStorageUsecase{
  final ChatRepository storageRepository;

  SendFileOnStorageUsecase(this.storageRepository);

  Future<Either<Failure,void>> call(XFile file, bool isVideo) async {
    print("UseCase par pocha hia");
    return  await storageRepository.sendFile(file, isVideo);
  }
}