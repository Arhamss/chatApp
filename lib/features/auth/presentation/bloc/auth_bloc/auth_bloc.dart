import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/features/auth/domain/use_cases/auth_use_cases.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.signInWithPhoneNumber, required this.verifyCode})
      : super(AuthInitial()) {
    on<PhoneNumberEntered>((event, emit) async {
      emit(AuthLoading());
      await _handlePhoneNumberVerification(event.phoneNumber, emit);
    });

    on<CaptchaCompleted>((event, emit) {
      emit(AuthCodeSent());
    });

    on<CodeEntered>((event, emit) async {
      emit(AuthLoading());
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: event.code,
      );
      try {
        await _firebaseAuth.signInWithCredential(credential);
        emit(AuthAuthenticated());
      } catch (e) {
        emit(const AuthError('Failed to verify code'));
      }
    });

    on<AddPhoneNumberDigit>((event, emit) {
      if (state is PhoneNumberEntryState) {
        final currentNumber =
            (state as PhoneNumberEntryState).enteredPhoneNumber;
        if (currentNumber.length < 10) {
          emit(PhoneNumberEntryState(currentNumber + event.digit));
        }
      } else {
        emit(PhoneNumberEntryState(event.digit));
      }
    });

    on<RemovePhoneNumberDigit>((event, emit) {
      if (state is PhoneNumberEntryState) {
        final currentNumber =
            (state as PhoneNumberEntryState).enteredPhoneNumber;
        if (currentNumber.isNotEmpty) {
          emit(
            PhoneNumberEntryState(
              currentNumber.substring(0, currentNumber.length - 1),
            ),
          );
        }
      }
    });

    on<AddDigit>((event, emit) {
      if (state is CodeEntryState) {
        final currentCode = (state as CodeEntryState).enteredCode;
        if (currentCode.length < 6) {
          emit(CodeEntryState(currentCode + event.digit));
        }
      } else {
        emit(CodeEntryState(event.digit));
      }
    });

    on<RemoveDigit>((event, emit) {
      if (state is CodeEntryState) {
        final currentCode = (state as CodeEntryState).enteredCode;
        if (currentCode.isNotEmpty) {
          emit(
            CodeEntryState(
              currentCode.substring(0, currentCode.length - 1),
            ),
          );
        }
      }
    });
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final SignInWithPhoneNumberUseCase signInWithPhoneNumber;
  final VerifyCodeUseCases verifyCode;
  String _verificationId = '';

  Future<void> _handlePhoneNumberVerification(
    String phoneNumber,
    Emitter<AuthState> emit,
  ) async {
    final completer = Completer<void>();
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          await _firebaseAuth.signInWithCredential(credential);
          if (!completer.isCompleted) {
            emit(AuthAuthenticated());
            completer.complete();
          }
        } catch (e) {
          if (!completer.isCompleted) {
            emit(AuthError(e.toString()));
            completer.complete();
          }
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        if (!completer.isCompleted) {
          emit(AuthError(e.message ?? 'Failed to verify phone number'));
          completer.complete();
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        if (!completer.isCompleted) {
          emit(AuthCodeSent());
          completer.complete();
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
    return completer.future;
  }

  void saveVerificationId(String verificationId) {
    _verificationId = verificationId;
  }
}
