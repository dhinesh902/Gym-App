import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym/controller/auth/auth_event.dart';
import 'package:gym/controller/auth/auth_state.dart';
import 'package:gym/models/auth_models.dart';
import 'package:gym/service/trainer_service.dart';
import 'package:gym/service/member_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final TrainerService trainerService;
  final MemberService memberService;

  AuthBloc({
    required this.trainerService,
    required this.memberService,
  }) : super(AuthInitial()) {
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterTrainerRequested>(_onAuthRegisterTrainerRequested);
    on<AuthRegisterMemberRequested>(_onAuthRegisterMemberRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      if (event.isTrainer) {
        final request = LoginRequest(
          email: event.email,
          password: event.password,
        );
        final response = await trainerService.loginTrainer(request);
        emit(AuthSuccess(response));
      } else {
        final request = LoginRequest(
          email: event.email,
          password: event.password,
        );
        final response = await memberService.loginMember(request);
        emit(AuthSuccess(response));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onAuthRegisterTrainerRequested(
    AuthRegisterTrainerRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await trainerService.registerTrainer(event.request);
      emit(AuthSuccess(response));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onAuthRegisterMemberRequested(
    AuthRegisterMemberRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await memberService.registerMember(event.request);
      emit(AuthSuccess(response));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await trainerService.logout();
    emit(AuthInitial());
  }
}
