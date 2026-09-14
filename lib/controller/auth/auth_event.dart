import 'package:flutter/foundation.dart';
import 'package:gym/models/auth_models.dart';

@immutable
abstract class AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;
  final bool isTrainer;

  AuthLoginRequested({
    required this.email,
    required this.password,
    this.isTrainer = false,
  });
}

class AuthRegisterTrainerRequested extends AuthEvent {
  final TrainerRegisterRequest request;

  AuthRegisterTrainerRequested(this.request);
}

class AuthRegisterMemberRequested extends AuthEvent {
  final MemberRegisterRequest request;

  AuthRegisterMemberRequested(this.request);
}

class AuthLogoutRequested extends AuthEvent {}
