part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class SaveProfileEvent extends ProfileEvent {
  const SaveProfileEvent(this.user);

  final UserModel user;

  @override
  List<Object?> get props => [user];
}

class PickImageEvent extends ProfileEvent {}
