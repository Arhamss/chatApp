part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class PhoneNumberEntered extends AuthEvent {
  const PhoneNumberEntered(this.phoneNumber);

  final String phoneNumber;

  @override
  List<Object> get props => [phoneNumber];
}

class CodeEntered extends AuthEvent {
  const CodeEntered(this.verificationId, this.code);

  final String verificationId;
  final String code;

  @override
  List<Object> get props => [verificationId, code];
}

class CaptchaCompleted extends AuthEvent {}

class AddPhoneNumberDigit extends AuthEvent {
  const AddPhoneNumberDigit(this.digit);

  final String digit;

  @override
  List<Object> get props => [digit];
}

class RemovePhoneNumberDigit extends AuthEvent {
  const RemovePhoneNumberDigit();

  @override
  List<Object> get props => [];
}

class AddDigit extends AuthEvent {
  const AddDigit(this.digit);

  final String digit;

  @override
  List<Object> get props => [digit];
}

class RemoveDigit extends AuthEvent {
  const RemoveDigit();

  @override
  List<Object> get props => [];
}
