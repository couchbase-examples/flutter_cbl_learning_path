import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';

import 'package:flutter_cbl_learning_path/features/login/bloc/bloc.dart';
import 'package:flutter_cbl_learning_path/features/router/route.dart';
import '../models/models.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FakeAuthenticationService _authenticationService;

  LoginBloc({required FakeAuthenticationService authenticationService})
      : _authenticationService = authenticationService,
        super(const LoginState()) {
    on<LoginUsernameChanged>(_onUsernameChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
    on<LogoutSubmitted>(_onLogoutSubmitted);
  }

  void _onUsernameChanged(
      LoginUsernameChanged event, Emitter<LoginState> emit) {
    final username = Username.dirty(event.username);
    emit(
      state.copyWith(
        username: username,
        status: Formz.validate([state.password, username]),
      ),
    );
  }

  void _onPasswordChanged(
      LoginPasswordChanged event, Emitter<LoginState> emit) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        status: Formz.validate([password, state.username]),
      ),
    );
  }

  void _onLogoutSubmitted(LogoutSubmitted event, Emitter<LoginState> emit) {
    _authenticationService.signOut();
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      try {
        var result = await _authenticationService.authenticateUser(
          username: state.username.value,
          password: state.password.value,
        );
        if (!result) {
          emit(state.copyWith(status: FormzStatus.submissionFailure));
        }
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      } catch (_) {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    }
  }
}
