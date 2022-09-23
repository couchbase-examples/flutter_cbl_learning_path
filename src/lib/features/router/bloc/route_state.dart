import 'package:equatable/equatable.dart';
import '../../login/models/user.dart';
import '../service/router_service.dart';
import '../service/auth_service.dart';

class RouteState extends Equatable {
  final AuthenticationStatus status;
  final User user;
  final ScreenRoute route;

  const RouteState(
      {this.status = AuthenticationStatus.unknown,
      this.user = User.empty,
      this.route = const ScreenRoute(routeToScreen: RouteToScreen.none, projectId: '', auditId: '')
      });

  const RouteState.unknown()
      : this(
            status: AuthenticationStatus.unknown,
            user: User.empty,
            route: const ScreenRoute(routeToScreen: RouteToScreen.none, projectId: '', auditId: ''));

  const RouteState.loggedOut()
      : this(
            status: AuthenticationStatus.logout,
            user: User.empty,
            route: const ScreenRoute(routeToScreen:RouteToScreen.logout ));

  const RouteState.authenticated(this.user)
      : status = AuthenticationStatus.authenticated,
        route = const ScreenRoute(routeToScreen:RouteToScreen.projects);

  const RouteState.unauthenticated()
      : this(
            status: AuthenticationStatus.unauthenticated,
            user: User.empty,
            route: const ScreenRoute(routeToScreen:RouteToScreen.none));

  const RouteState.authenticatedFailed()
      : this(
            status: AuthenticationStatus.authenticatedFailed,
            user: User.empty,
            route: const ScreenRoute(routeToScreen:RouteToScreen.none));

  const RouteState.developer()
      : this(
            status: AuthenticationStatus.authenticated,
            user: User.empty,
            route: const ScreenRoute(routeToScreen:RouteToScreen.developer));

  const RouteState.developerInfo()
      : this(
            status: AuthenticationStatus.authenticated,
            user: User.empty,
            route: const ScreenRoute(routeToScreen:RouteToScreen.developerInfo));

  const RouteState.projects()
      : this(
            status: AuthenticationStatus.authenticated,
            user: User.empty,
            route: const ScreenRoute(routeToScreen:RouteToScreen.projects));

  const RouteState.projectEditor({route = ScreenRoute})
      : this(
            status: AuthenticationStatus.authenticated,
            user: User.empty,
            route: route);

  const RouteState.audits({route = ScreenRoute})
      : this(
            status: AuthenticationStatus.authenticated,
            user: User.empty,
            route: route);

  const RouteState.auditEditor({route = ScreenRoute})
      : this(
            status: AuthenticationStatus.authenticated,
            user: User.empty,
            route: route);
  const RouteState.userProfileEditor()
      : this(
            status: AuthenticationStatus.authenticated,
            user: User.empty,
            route: const ScreenRoute(routeToScreen: RouteToScreen.userProfileEditor));
  const RouteState.replicator()
      : this(
            status: AuthenticationStatus.authenticated,
            user: User.empty,
            route: const ScreenRoute(routeToScreen:RouteToScreen.replicator));

  const RouteState.replicatorConfig()
      : this(
            status: AuthenticationStatus.authenticated,
            user: User.empty,
            route: const ScreenRoute(routeToScreen:RouteToScreen.replicatorConfig));

  const RouteState.pop()
      : this(
            status: AuthenticationStatus.authenticated,
            user: User.empty,
            route: const ScreenRoute(routeToScreen:RouteToScreen.pop));

  @override
  List<Object> get props => [status, user, route];
}
