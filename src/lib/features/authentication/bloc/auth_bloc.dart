import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../login/models/user.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'auth_service.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final FakeAuthenticationService _authenticationService;
  late StreamSubscription<AuthenticationStatus>
      _authenticationStatusSubscription;

  AuthenticationBloc(this._authenticationService)
      : super(const AuthenticationState.unknown()) {
    on<AuthenticationEvent>((event, emit) {
      if (event is AppLoaded) {
        _handleAppLoaded(event, emit);
      } else if (event is UserLoggedIn) {
        _handleUserLoggedIn(event, emit);
      } else if (event is UserLoggedOut) {
        _handleUserLoggedOut(event, emit);
      }
    });
    on<AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    _authenticationStatusSubscription = _authenticationService.status.listen(
      (status) => add(AuthenticationStatusChanged(status)),
    );
  }

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    _authenticationService.dispose();
    return super.close();
  }

  Future<void> _onAuthenticationStatusChanged(
    AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        return emit(const AuthenticationState.unauthenticated());
      case AuthenticationStatus.authenticated:
        final user = await _tryGetUser();
        return emit(
          user != null
              ? AuthenticationState.authenticated(user)
              : const AuthenticationState.unauthenticated(),
        );
      case AuthenticationStatus.unknown:
        return emit(const AuthenticationState.unknown());
      case AuthenticationStatus.authenticatedFailed:
        return emit(const AuthenticationState.authenticatedFailed());
      case AuthenticationStatus.logout:
        return emit(const AuthenticationState.loggedOut());
    }
  }

  void _handleAppLoaded(
      AppLoaded event, Emitter<AuthenticationState> emit) async {}

  void _handleUserLoggedIn(
      UserLoggedIn event, Emitter<AuthenticationState> emit) {
    emit(AuthenticationState.authenticated(event.user));
  }

  void _handleUserLoggedOut(
      UserLoggedOut event, Emitter<AuthenticationState> emit) async {
    await _authenticationService.signOut();
    emit(const AuthenticationState.unauthenticated());
  }

  Future<User?> _tryGetUser() async {
    try {
      final currentUser = await _authenticationService.getCurrentUser();
      return currentUser;
    } catch (e) {
      return null;
    }
  }
}
