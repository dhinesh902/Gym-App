import 'package:flutter/foundation.dart';
import 'package:gym/models/auth_models.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final AuthResponse response;

  AuthSuccess(this.response);
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure(this.error);
}
