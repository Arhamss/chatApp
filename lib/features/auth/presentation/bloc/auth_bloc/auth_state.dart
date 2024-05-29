part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthCodeSent extends AuthState {}

class AuthAuthenticated extends AuthState {}

class AuthError extends AuthState {
  const AuthError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class CaptchaVerificationPending extends AuthState {}

class PhoneNumberEntryState extends AuthState {
  const PhoneNumberEntryState(this.enteredPhoneNumber);

  final String enteredPhoneNumber;

  @override
  List<Object> get props => [enteredPhoneNumber];
}

class CodeEntryState extends AuthState {
  const CodeEntryState(this.enteredCode);

  final String enteredCode;

  @override
  List<Object> get props => [enteredCode];
}
