import 'package:bloc/bloc.dart';
import 'package:chat_app/features/auth/domain/use_cases/auth_use_cases.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.signInWithPhoneNumber, required this.verifyCode})
      : super(AuthInitial()) {
    on<PhoneNumberEntered>((event, emit) async {
      emit(AuthLoading());
      final failureOrSuccess =
          await signInWithPhoneNumber.call(event.phoneNumber);
      failureOrSuccess.fold(
        (failure) => emit(const AuthError('Failed to send verification code')),
        (_) => emit(AuthCodeSent()),
      );
    });

    on<CodeEntered>((event, emit) async {
      emit(AuthLoading());
      final failureOrSuccess = await verifyCode.call(event.code);
      failureOrSuccess.fold(
        (failure) => emit(const AuthError('Failed to verify code')),
        (_) => emit(AuthAuthenticated()),
      );
    });
  }

  final SignInWithPhoneNumberUseCase signInWithPhoneNumber;
  final VerifyCodeUseCases verifyCode;
  String _verificationId = '';

  void saveVerificationId(String verificationId) {
    _verificationId = verificationId;
  }
}
