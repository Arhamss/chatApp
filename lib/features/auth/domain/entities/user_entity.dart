class UserEntity {
  const UserEntity({
    required this.id,
    required this.firstName,
    required this.phoneNumber,
    required this.photoUrl,
    required this.lastName,
  });

  final String id;
  final String firstName;
  final String phoneNumber;
  final String photoUrl;
  final String lastName;
}
