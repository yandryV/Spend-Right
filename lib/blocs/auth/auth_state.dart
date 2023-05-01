part of 'auth_bloc.dart';

@immutable
class AuthState {
  final String email;
  final bool emailState;
  final String password;
  final bool passwordState;
  final String confirmPassword;
  final bool confirmPasswordState;
  final bool loginButtonState;
  final bool isLoading;
  final String? error;
  final dynamic response;

  const AuthState(
      {this.email = "",
      this.emailState = true,
      this.password = "",
      this.passwordState = true,
      this.confirmPassword = "",
      this.confirmPasswordState = true,
      this.loginButtonState = false,
      this.isLoading = false,
      this.error,
      this.response});

  AuthState copyWith(
          {String? email,
          bool? emailState,
          String? password,
          bool? passwordState,
          String? confirmPassword,
          bool? confirmPasswordState,
          bool? loginButtonState,
          bool? isLoading,
          String? error,
          dynamic response}) =>
      AuthState(
          email: email ?? this.email,
          emailState: emailState ?? this.emailState,
          password: password ?? this.password,
          passwordState: passwordState ?? this.passwordState,
          confirmPassword: confirmPassword ?? this.confirmPassword,
          confirmPasswordState:
              confirmPasswordState ?? this.confirmPasswordState,
          loginButtonState: loginButtonState ?? this.loginButtonState,
          isLoading: isLoading ?? this.isLoading,
          error: error ?? this.error,
          response: response ?? this.response);
}
