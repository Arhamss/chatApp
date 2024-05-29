import 'package:bloc/bloc.dart';
import 'package:chat_app/features/auth/presentation/bloc/profile_bloc/profile_event.dart';
import 'package:chat_app/features/auth/presentation/bloc/profile_bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<SaveProfile>((event, emit) async {
      emit(ProfileSaving());
      try {
        await Future.delayed(const Duration(seconds: 2));
        emit(ProfileSaveSuccess());
      } catch (e) {
        emit(const ProfileSaveFailure('Failed to save profile'));
      }
    });
  }
}
