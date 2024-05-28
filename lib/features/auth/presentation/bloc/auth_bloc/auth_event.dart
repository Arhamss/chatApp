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
  const CodeEntered(this.code);

  final String code;

  @override
  List<Object> get props => [code];
}
