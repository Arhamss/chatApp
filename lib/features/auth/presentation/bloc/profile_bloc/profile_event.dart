import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class SaveProfile extends ProfileEvent {
  final String firstName;
  final String lastName;

  const SaveProfile(this.firstName, this.lastName);

  @override
  List<Object?> get props => [firstName, lastName];
}
