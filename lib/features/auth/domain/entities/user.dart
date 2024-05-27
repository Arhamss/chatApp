import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({required this.id, required this.name, required this.phoneNumber});
  final String id;
  final String name;
  final String phoneNumber;

  @override
  List<Object?> get props => [id, name, phoneNumber];
}
