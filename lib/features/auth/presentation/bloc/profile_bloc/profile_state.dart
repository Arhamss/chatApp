import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileSaving extends ProfileState {}

class ProfileSaveSuccess extends ProfileState {}

class ProfileSaveFailure extends ProfileState {
  final String message;

  const ProfileSaveFailure(this.message);

  @override
  List<Object?> get props => [message];
}
