class ContactEntity {
  const ContactEntity({
    required this.id,
    required this.contactUserId,
    required this.name,
    required this.phone,
    this.photoUrl,
  });

  final String id;
  final String contactUserId;
  final String name;
  final String phone;
  final String? photoUrl;
}
