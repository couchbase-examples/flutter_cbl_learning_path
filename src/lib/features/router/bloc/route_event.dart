import 'package:equatable/equatable.dart';
import '../service/auth_service.dart';
import '../service/router_service.dart';

abstract class RouteEvent extends Equatable {
  const RouteEvent();

  @override
  List<Object> get props => [];
}

// Fired just after the app is launched
class AppLoaded extends RouteEvent {}

// Fired when the user has logged out
class UserLoggedOut extends RouteEvent {}

class AuthenticationStatusChanged extends RouteEvent {
  const AuthenticationStatusChanged(this.status);

  final AuthenticationStatus status;

  @override
  List<Object> get props => [status];
}

class RouteChanged extends RouteEvent {
  const RouteChanged(this.route);
  final ScreenRoute route;

  @override
  List<Object> get props => [route];
}
