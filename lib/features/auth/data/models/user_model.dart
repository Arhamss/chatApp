import 'package:chat_app/features/auth/domain/entities/user_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';

part 'user_model.g.dart';

@freezed
class UserModel extends UserEntity with _$UserModel {
  const factory UserModel({
    required String id,
    required String phoneNumber,
    required String lastName,
    required String photoUrl,
    required String firstName,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, Object?> json) =>
      _$UserModelFromJson(json);

// factory MessageModel.fromJson(Map<String, Object?> json) {
//   json['timestamp'] = (json['timestamp']! as Timestamp).toDate().toString();
//   return _$MessageModelFromJson(json);
// }
}
