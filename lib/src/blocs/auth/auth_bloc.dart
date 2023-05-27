import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spend_right/src/blocs/auth/auth_functions.dart';
import 'package:spend_right/src/helpers/preferences.dart';
import 'package:spend_right/src/models/user_model.dart';
import 'package:spend_right/src/services/firebase_auth.dart';
import 'package:spend_right/src/services/firebase_database.dart';
import 'package:spend_right/src/services/firebase_storage.dart';

import 'dart:io';

import '../navigation/navigation_bloc.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final NavigationBloc _navigationBloc;
  final firebaseServicesAuth = FirebaseServicesAuth();
  final firebaseServicesDatabase = FirebaseServicesDatabase();
  final firebaseServicesStorage = FirebaseServicesStorage();

  final preferences = Preferences();

  AuthBloc(this._navigationBloc) : super(const AuthState()) {
    on<OnEmailChange>(_mapOnEmailChange);
    on<OnPasswordChange>(_mapOnPasswordChange);
    on<OnConfirmPasswordChange>(_mapOnConfirmPasswordChange);
    on<OnLoginRequestWithEmail>(_mapOnLoginRequestWithEmail);
    on<OnUpdateUserInformation>(_mapOnUpdateUserInformation);
    on<OnSignInRequestWithEmail>(_mapOnSignInRequestWithEmail);
  }

  void _mapOnEmailChange(event, Emitter emit) async {
    final emailState = validarCorreo(event.email, state.passwordState);
    emit(state.copyWith(
        email: event.email,
        emailState: emailState[0],
        loginButtonState: emailState[1]));
  }

  void _mapOnPasswordChange(event, Emitter emit) async {
    final passwordState = passwordValidator(event.password, state.emailState);
    bool confirmPasswordState = true;
    if (state.confirmPassword.isNotEmpty) {
      confirmPasswordState =
          confirmPasswordValidator(event.password, state.confirmPassword);
    }
    emit(state.copyWith(
      password: event.password,
      passwordState: passwordState[0],
      loginButtonState: passwordState[0],
      confirmPasswordState: confirmPasswordState,
    ));
  }

  void _mapOnConfirmPasswordChange(event, Emitter emit) async {
    final confirmPasswordState =
        confirmPasswordValidator(state.password, event.confirmPassword);
    emit(state.copyWith(
      confirmPassword: event.confirmPassword,
      confirmPasswordState: confirmPasswordState,
    ));
  }

  void _mapOnLoginRequestWithEmail(event, Emitter emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      final credential = await firebaseServicesAuth.signInWithEmail(
          state.email, state.password);
      if (credential == null) return null;
      User? userFirebase = credential.user;
      if (userFirebase != null) {
        final user =
            await firebaseServicesDatabase.getUserData(userFirebase.uid);
        if (user.profileCompleted()) {
          preferences.user = user.toEncodeJson();
          _navigationBloc
              .add(NavigateToPage("/welcome", "pushReplacementNamed"));
        } else {
          final newUser = UserModel().init();
          newUser.uid = userFirebase.uid;
          newUser.email = userFirebase.email!;
          newUser.name = userFirebase.displayName ?? '';
          preferences.user = newUser.toEncodeJson();
          _navigationBloc.add(NavigateToPage("/user-register", "pushNamed"));
        }
      }
      emit(state.copyWith(
        isLoading: false,
      ));
    } on FirebaseAuthException catch (e) {
      _navigationBloc.add(ShowSnackBar(e.message.toString(), "error"));
      emit(state.copyWith(isLoading: false));
    } on Exception catch (e) {
      _navigationBloc.add(ShowSnackBar(e.toString(), "error"));
      emit(state.copyWith(isLoading: false));
    }
  }

  void _mapOnUpdateUserInformation(event, Emitter emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      // TODO:Upload photo
      // if (event.user.photoUrl == "") {
      //   event.user.photoUrl = await firebaseServicesStorage.uploadPhoto(
      //       event.photo, event.user.uid);
      // }
      final postUserData =
          await firebaseServicesDatabase.postUserData(event.user);
      if (postUserData) {
        preferences.user = event.user.toEncodeJson();
        _navigationBloc.add(NavigateToPage("/welcome", "pushNamed"));
      }
      emit(state.copyWith(
        isLoading: false,
      ));
    } on FirebaseAuthException catch (e) {
      _navigationBloc.add(ShowSnackBar(e.message.toString(), "error"));
      emit(state.copyWith(isLoading: false));
    } on Exception catch (e) {
      _navigationBloc.add(ShowSnackBar(e.toString(), "error"));
      emit(state.copyWith(isLoading: false));
    }
  }

  void _mapOnSignInRequestWithEmail(event, Emitter emit) async {
    try {
      await firebaseServicesAuth
          .createAccount(state.email, state.password)
          .then((User? userFirebase) async {
        if (userFirebase != null) {
          final newUser = UserModel().init();
          newUser.uid = userFirebase.uid;
          newUser.email = userFirebase.email!;
          newUser.name = userFirebase.displayName ?? '';
          preferences.user = newUser.toEncodeJson();
          _navigationBloc.add(NavigateToPage("/user-register", "pushNamed"));
        }
      });
    } on FirebaseAuthException catch (e) {
      _navigationBloc.add(ShowSnackBar(e.message.toString(), "error"));
      emit(state.copyWith(isLoading: false));
    } on Exception catch (e) {
      _navigationBloc.add(ShowSnackBar(e.toString(), "error"));
      emit(state.copyWith(isLoading: false));
    }
  }
}
