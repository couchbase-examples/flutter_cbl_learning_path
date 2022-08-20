import 'package:equatable/equatable.dart';
import '../../login/models/user.dart';
import './auth_service.dart';

class AuthenticationState extends Equatable {
  final AuthenticationStatus status;
  final User user;

  const AuthenticationState(
      {this.status = AuthenticationStatus.unknown, this.user = User.empty});

  const AuthenticationState.unknown()
      : this(status: AuthenticationStatus.unknown, user: User.empty);

  const AuthenticationState.loggedOut()
      : this(status: AuthenticationStatus.logout, user: User.empty);

  const AuthenticationState.authenticated(this.user)
      : status = AuthenticationStatus.authenticated;

  const AuthenticationState.unauthenticated()
      : this(status: AuthenticationStatus.unauthenticated, user: User.empty);
  const AuthenticationState.authenticatedFailed()
      : this(
            status: AuthenticationStatus.authenticatedFailed, user: User.empty);

  @override
  List<Object> get props => [status, user];
}
