part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileSaving extends ProfileState {}

class ProfileSaveSuccess extends ProfileState {}

class ProfileSaveFailure extends ProfileState {
  const ProfileSaveFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class ImagePickedState extends ProfileState {
  const ImagePickedState(this.imagePath);

  final String imagePath;

  @override
  List<Object?> get props => [imagePath];
}
