import 'package:chat_app/features/contact/domain/entities/contact_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_model.freezed.dart';

part 'contact_model.g.dart';

@freezed
class ContactModel extends ContactEntity with _$ContactModel {
  const factory ContactModel({
    required String id,
    required String contactUserId,
    required String name,
    required String phone,
    String? photoUrl,
  }) = _ContactModel;

  factory ContactModel.fromJson(Map<String, Object?> json) =>
      _$ContactModelFromJson(json);
}
