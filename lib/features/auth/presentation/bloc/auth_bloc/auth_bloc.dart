import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:chat_app/features/auth/domain/use_cases/auth_use_cases.dart';
import 'package:chat_app/features/auth/domain/use_cases/get_user_by_id_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required this.signInWithPhoneNumber,
    required this.verifyCode,
    required this.getUserByIdUseCase,
    required this.notificationUseCases,
    required this.authUseCases,
  }) : super(AuthInitial()) {
    on<SignOutUserEvent>(_onSignOutUser);
    on<PhoneNumberEntered>(_onPhoneNumberEntered);
    on<CodeEntered>(_onCodeEntered);
    on<CaptchaCompleted>(_onCaptchaCompleted);
    on<AddPhoneNumberDigit>(_onAddPhoneNumberDigit);
    on<RemovePhoneNumberDigit>(_onRemovePhoneNumberDigit);
    on<AddDigit>(_onAddDigit);
    on<RemoveDigit>(_onRemoveDigit);
    on<GetUserDetailsEvent>(_onGetUserDetails);
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final SignInWithPhoneNumberUseCase signInWithPhoneNumber;
  final VerifyCodeUseCases verifyCode;
  final GetUserByIdUseCase getUserByIdUseCase;
  final NotificationUseCases notificationUseCases;
  final AuthUseCases authUseCases;
  String verificationId = '';


  Future<void> _onSignOutUser(
    SignOutUserEvent event,
    Emitter<AuthState> emit,
    ) async {
    try{
      emit(AuthLoading());
      await notificationUseCases.unSubscribeTopic();
      await authUseCases.signOutUser();
      emit(AuthSuccess());
    }
    catch (e) {
      emit(const AuthError('Error signing out'));
    }
  } 

  Future<void> _onPhoneNumberEntered(
    PhoneNumberEntered event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading()); 
    // final messaging = GetIt.instance<FirebaseMessaging>();
    //       // final phoneNumber = _sanitizeTopicName(event.phoneNumber);

    // messaging.unsubscribeFromTopic("03068555581");
    // messaging.unsubscribeFromTopic("03101046849");
    // messaging.unsubscribeFromTopic("03014189946");
    // //       messaging.subscribeToTopic(phoneNumber);


    await notificationUseCases.subscribeTopic(event.phoneNumber);
    await _handlePhoneNumberVerification(event.phoneNumber, emit);
  }

  Future<void> _onCodeEntered(
    CodeEntered event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final credential = PhoneAuthProvider.credential(
      verificationId: event.verificationId,
      smsCode: event.code,
    );
    try {
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      emit(AuthAuthenticated());
      add(GetUserDetailsEvent(userCredential.user!.uid));
    } catch (e) {
      emit(const AuthError('Failed to verify code'));
    }
  }

  void _onCaptchaCompleted(
    CaptchaCompleted event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthCodeSent(verificationId));
  }

  void _onAddPhoneNumberDigit(
    AddPhoneNumberDigit event,
    Emitter<AuthState> emit,
  ) {
    if (state is PhoneNumberEntryState) {
      final currentNumber = (state as PhoneNumberEntryState).enteredPhoneNumber;
      if (currentNumber.length < 10) {
        emit(PhoneNumberEntryState(currentNumber + event.digit));
      }
    } else {
      emit(PhoneNumberEntryState(event.digit));
    }
  }

  void _onRemovePhoneNumberDigit(
    RemovePhoneNumberDigit event,
    Emitter<AuthState> emit,
  ) {
    if (state is PhoneNumberEntryState) {
      final currentNumber = (state as PhoneNumberEntryState).enteredPhoneNumber;
      if (currentNumber.isNotEmpty) {
        emit(
          PhoneNumberEntryState(
            currentNumber.substring(0, currentNumber.length - 1),
          ),
        );
      }
    }
  }

  void _onAddDigit(
    AddDigit event,
    Emitter<AuthState> emit,
  ) {
    if (state is CodeEntryState) {
      final currentCode = (state as CodeEntryState).enteredCode;
      if (currentCode.length < 6) {
        emit(CodeEntryState(currentCode + event.digit));
      }
    } else {
      emit(CodeEntryState(event.digit));
    }
  }

  void _onRemoveDigit(
    RemoveDigit event,
    Emitter<AuthState> emit,
  ) {
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
  }

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
        this.verificationId = verificationId;

        if (!completer.isCompleted) {
          emit(AuthCodeSent(verificationId));
          completer.complete();
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        this.verificationId = verificationId;
      },
    );

    return completer.future;
  }

  Future<void> _onGetUserDetails(
    GetUserDetailsEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(FetchingUserDetailsState(event.userId));
    final result = await getUserByIdUseCase(event.userId);
    result.fold(
      (failure) => emit(const AuthError('Failed to fetch user details')),
      (user) => emit(UserDetailsFetchedState(user)),
    );
  }
}
