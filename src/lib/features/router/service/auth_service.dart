import 'dart:async';
import '../../login/models/user.dart';

enum AuthenticationStatus {
  unknown,
  authenticated,
  unauthenticated,
  authenticatedFailed,
  logout
}

abstract class AuthenticationService {
  Future<User?> getCurrentUser();
  Future<void> authenticateUser(
      {required String username, required String password});
  Future<void> signOut();
  Stream<AuthenticationStatus> get status;
}

class FakeAuthenticationService extends AuthenticationService {

  FakeAuthenticationService() {
    _user = null;
  }

  final _controller = StreamController<AuthenticationStatus>();
  User? _user;

  void dispose() => _controller.close();

  @override
  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(milliseconds: 20));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  @override
  Future<User?> getCurrentUser() async => _user;

  @override
  Future<void> signOut() async {
    _user = null;
    _controller.add(AuthenticationStatus.logout);
  }

  @override
  Future<bool> authenticateUser(
      {required String username, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 50));
    try {
      _user = null;
      _user = _users
          .where((i) => i.username == username && i.password == password)
          .first;
      if (_user == null) {
        _controller.add(AuthenticationStatus.authenticatedFailed);
      } else {
        _controller.add(AuthenticationStatus.authenticated);
        return true;
      }
    } catch (e) {
      _controller.add(AuthenticationStatus.authenticatedFailed);
    }
    return false;
  }

  final List<User> _users = [
    const User(
        username: 'demo@example.com', password: 'P@ssw0rd12', team: 'team1'),
    const User(
        username: 'demo1@example.com', password: 'P@ssw0rd12', team: 'team1'),
    const User(
        username: 'demo2@example.com', password: 'P@ssw0rd12', team: 'team2'),
    const User(
        username: 'demo3@example.com', password: 'P@ssw0rd12', team: 'team2'),
    const User(
        username: 'demo4@example.com', password: 'P@ssw0rd12', team: 'team3'),
    const User(
        username: 'demo5@example.com', password: 'P@ssw0rd12', team: 'team3'),
    const User(
        username: 'demo6@example.com', password: 'P@ssw0rd12', team: 'team4'),
    const User(
        username: 'demo7@example.com', password: 'P@ssw0rd12', team: 'team4'),
    const User(
        username: 'demo8@example.com', password: 'P@ssw0rd12', team: 'team5'),
    const User(
        username: 'demo9@example.com', password: 'P@ssw0rd12', team: 'team5'),
    const User(
        username: 'demo10@example.com', password: 'P@ssw0rd12', team: 'team6'),
    const User(
        username: 'demo11@example.com', password: 'P@ssw0rd12', team: 'team6'),
    const User(
        username: 'demo12@example.com', password: 'P@ssw0rd12', team: 'team7'),
    const User(
        username: 'demo13@example.com', password: 'P@ssw0rd12', team: 'team8'),
    const User(
        username: 'demo14@example.com', password: 'P@ssw0rd12', team: 'team9'),
    const User(
        username: 'demo15@example.com', password: 'P@ssw0rd12', team: 'team10'),
  ];
}
