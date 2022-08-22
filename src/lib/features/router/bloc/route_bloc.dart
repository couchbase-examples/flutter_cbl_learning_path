import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_cbl_learning_path/features/router/route.dart';
import '../../login/models/user.dart';

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  final FakeAuthenticationService _authenticationService;
  final AppRouterService _routerService;

  late StreamSubscription<AuthenticationStatus>
      _authenticationStatusSubscription;
  // ignore: unused_field
  late StreamSubscription<RouteToScreen> _routeToScreenSubscription;

  RouteBloc(this._authenticationService, this._routerService)
      : super(const RouteState.unknown()) {
    on<RouteEvent>((event, emit) {
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

    on<RouteChanged>(_onRouteChanged);
    _routeToScreenSubscription = _routerService.route.listen(
      (route) => add(RouteChanged(route)),
    );
  }

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    _authenticationService.dispose();
    return super.close();
  }

  void _onRouteChanged(RouteChanged event, Emitter<RouteState> emit) {
    switch (event.route) {
      case RouteToScreen.developer:
        emit(const RouteState.developer());
        break;
      case RouteToScreen.developerInfo:
        emit(const RouteState.developerInfo());
        break;
      case RouteToScreen.projects:
        emit(const RouteState.projects());
        break;
      case RouteToScreen.projectEditor:
        emit(const RouteState.projectEditor());
        break;
      case RouteToScreen.audits:
        emit(const RouteState.audits());
        break;
      case RouteToScreen.auditEditor:
        emit(const RouteState.auditEditor());
        break;
      case RouteToScreen.replicator:
        emit(const RouteState.replicator());
        break;
      case RouteToScreen.replicatorConfig:
        emit(const RouteState.replicatorConfig());
        break;
      default:
        break;
    }
  }

  Future<void> _onAuthenticationStatusChanged(
    AuthenticationStatusChanged event,
    Emitter<RouteState> emit,
  ) async {
    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        return emit(const RouteState.unauthenticated());
      case AuthenticationStatus.authenticated:
        final user = await _tryGetUser();
        return emit(
          user != null
              ? RouteState.authenticated(user)
              : const RouteState.unauthenticated(),
        );
      case AuthenticationStatus.unknown:
        return emit(const RouteState.unknown());
      case AuthenticationStatus.authenticatedFailed:
        return emit(const RouteState.authenticatedFailed());
      case AuthenticationStatus.logout:
        return emit(const RouteState.loggedOut());
    }
  }

  void _handleAppLoaded(AppLoaded event, Emitter<RouteState> emit) async {}

  void _handleUserLoggedIn(UserLoggedIn event, Emitter<RouteState> emit) {
    emit(RouteState.authenticated(event.user));
  }

  void _handleUserLoggedOut(
      UserLoggedOut event, Emitter<RouteState> emit) async {
    await _authenticationService.signOut();
    emit(const RouteState.unauthenticated());
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
