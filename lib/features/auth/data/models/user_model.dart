import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.phoneNumber,
    this.firstName,
    this.lastName,
    this.photoUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      phoneNumber: json['phoneNumber'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      photoUrl: json['photoUrl'] as String?,
    );
  }

  final String id;
  final String phoneNumber;
  final String? firstName;
  final String? lastName;
  final String? photoUrl;

  @override
  List<Object?> get props => [id, phoneNumber, firstName, lastName, photoUrl];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'firstName': firstName,
      'lastName': lastName,
      'photoUrl': photoUrl,
    };
  }
}
