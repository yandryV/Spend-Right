part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent  {}

class OnEmailChange extends AuthEvent {
  final String email;
  OnEmailChange(this.email);
}

class OnPasswordChange extends AuthEvent {
  final String password;
  OnPasswordChange(this.password);
}

class OnConfirmPasswordChange extends AuthEvent {
  final String confirmPassword;
  OnConfirmPasswordChange(this.confirmPassword);
}

class OnLoginRequestWithEmail extends AuthEvent {}

class OnSignInRequestWithEmail extends AuthEvent {}

//TODO: IMPLEMENTAR login con google acc

class OnLoginSuccess extends AuthEvent {}
// class OnLoginRequest extends AuthEvent {}
