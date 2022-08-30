import 'package:equatable/equatable.dart';
import '../../login/models/user.dart';
import '../service/router_service.dart';
import '../service/auth_service.dart';

class RouteState extends Equatable {
  final AuthenticationStatus status;
  final User user;
  final RouteToScreen route;

  const RouteState(
      {this.status = AuthenticationStatus.unknown,
      this.user = User.empty,
      this.route = RouteToScreen.none});

  const RouteState.unknown()
      : this(
            status: AuthenticationStatus.unknown,
            user: User.empty,
            route: RouteToScreen.none);

  const RouteState.loggedOut()
      : this(
            status: AuthenticationStatus.logout,
            user: User.empty,
            route: RouteToScreen.logout);

  const RouteState.authenticated(this.user)
      : status = AuthenticationStatus.authenticated,
        route = RouteToScreen.projects;

  const RouteState.unauthenticated()
      : this(
            status: AuthenticationStatus.unauthenticated,
            user: User.empty,
            route: RouteToScreen.none);

  const RouteState.authenticatedFailed()
      : this(
            status: AuthenticationStatus.authenticatedFailed,
            user: User.empty,
            route: RouteToScreen.none);

  const RouteState.developer()
      : this(
            status: AuthenticationStatus.authenticated,
            user: User.empty,
            route: RouteToScreen.developer);

  const RouteState.developerInfo()
      : this(
            status: AuthenticationStatus.authenticated,
            user: User.empty,
            route: RouteToScreen.developerInfo);

  const RouteState.projects()
      : this(
            status: AuthenticationStatus.authenticated,
            user: User.empty,
            route: RouteToScreen.projects);

  const RouteState.projectEditor()
      : this(
            status: AuthenticationStatus.authenticated,
            user: User.empty,
            route: RouteToScreen.projectEditor);

  const RouteState.audits()
      : this(
            status: AuthenticationStatus.authenticated,
            user: User.empty,
            route: RouteToScreen.audits);

  const RouteState.auditEditor()
      : this(
            status: AuthenticationStatus.authenticated,
            user: User.empty,
            route: RouteToScreen.auditEditor);

  const RouteState.replicator()
      : this(
            status: AuthenticationStatus.authenticated,
            user: User.empty,
            route: RouteToScreen.replicator);

  const RouteState.replicatorConfig()
      : this(
            status: AuthenticationStatus.authenticated,
            user: User.empty,
            route: RouteToScreen.replicatorConfig);

  const RouteState.pop()
      : this(
            status: AuthenticationStatus.authenticated,
            user: User.empty,
            route: RouteToScreen.pop);

  @override
  List<Object> get props => [status, user, route];
}
