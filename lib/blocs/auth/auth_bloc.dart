import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../navigation/navigation_bloc.dart';
part 'auth_event.dart';
part 'auth_state.dart';

// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   final NavigationBloc _navigationBloc;
//   final firebaseServicesAuth = FirebaseServicesAuth();
//   final firebaseServicesDatabase = FirebaseServicesDatabase();
//   final firebaseServicesStorage = FirebaseServicesStorage();
// }

//   AuthBloc(this._navigationBloc) : super(const AuthState()) {

//   }