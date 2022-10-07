import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_cbl_learning_path/features/database/replicator_provider.dart';
import 'package:flutter_cbl_learning_path/features/router/route.dart';
import 'package:flutter_cbl_learning_path/features/database/database.dart';
import 'package:flutter_cbl_learning_path/features/login/models/user.dart';

class RouteBloc extends Bloc<RouteEvent, RouteState> {

  RouteBloc(
      this._authenticationService,
      this._routerService,
      this._databaseProvider,
      this._replicatorProvider)
      : super(const RouteState.unknown())
  {
    on<RouteEvent>((event, emit) {
      if (event is AppLoaded) {
        _handleAppLoaded(event, emit);
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

  final FakeAuthenticationService _authenticationService;
  final AppRouterService _routerService;
  final DatabaseProvider _databaseProvider;
  final ReplicatorProvider _replicatorProvider;

  late StreamSubscription<AuthenticationStatus>
      _authenticationStatusSubscription;
  // ignore: unused_field
  late StreamSubscription<ScreenRoute> _routeToScreenSubscription;

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    _authenticationService.dispose();
    return super.close();
  }

  void _onRouteChanged(RouteChanged event, Emitter<RouteState> emit) {
    switch (event.route.routeToScreen) {
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
        emit(RouteState.projectEditor(route: event.route));
        break;
      case RouteToScreen.audits:
        emit(RouteState.audits(route: event.route));
        break;
      case RouteToScreen.auditEditor:
        emit(RouteState.auditEditor(route: event.route));
        break;
      case RouteToScreen.replicator:
        emit(const RouteState.replicator());
        break;
      case RouteToScreen.replicatorConfig:
        emit(const RouteState.replicatorConfig());
        break;
      case RouteToScreen.userProfileEditor:
        emit(const RouteState.userProfileEditor());
        break;
      case RouteToScreen.pop:
        emit(const RouteState.pop());
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
        if (user != null) {
          //init the database of the logged in user
          await _databaseProvider.initDatabases(user: user);

          //init replicator with config
          //NOTE YOU MUST CHANGE THE CONFIG IN THE
          //replicator_provider.dart FILE BEFORE
          //UNCOMMENTING OUT THIS CODE

          //await _replicatorProvider.init();

          return emit(RouteState.authenticated(user));
        }
        return emit(const RouteState.unauthenticated());
      case AuthenticationStatus.unknown:
        return emit(const RouteState.unknown());
      case AuthenticationStatus.authenticatedFailed:
        return emit(const RouteState.authenticatedFailed());
      case AuthenticationStatus.logout:
        {
          //stop the replicator if running
          await _replicatorProvider.stopReplicator();

          //close the databases
          await _databaseProvider.closeDatabases();
          return emit(const RouteState.loggedOut());
        }
    }
  }

  void _handleAppLoaded(AppLoaded event, Emitter<RouteState> emit) async {
    //init the database provider to setup cbl for use
    await _databaseProvider.initialize();
  }

  void _handleUserLoggedOut(
      UserLoggedOut event, Emitter<RouteState> emit) async {
    //make sure current user is signed out
    await _authenticationService.signOut();

    //close database
    _databaseProvider.closeDatabases();

    //send message to update back to login screen
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
