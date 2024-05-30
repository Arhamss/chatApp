import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:chat_app/features/auth/domain/use_cases/save_profile_use_cases.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final SaveProfileUseCase saveProfileUseCase;

  ProfileBloc({required this.saveProfileUseCase}) : super(ProfileInitial()) {
    on<SaveProfileEvent>(_onSaveProfile);
    on<PickImageEvent>(_onPickImage);
  }

  Future<void> _onSaveProfile(
    SaveProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileSaving());

    final result = await saveProfileUseCase(event.user);

    result.fold(
      (failure) => emit(ProfileSaveFailure(failure.toString())),
      (success) => emit(ProfileSaveSuccess()),
    );
  }

  Future<void> _onPickImage(
    PickImageEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      emit(ImagePickedState(pickedFile.path));
    }
  }
}
