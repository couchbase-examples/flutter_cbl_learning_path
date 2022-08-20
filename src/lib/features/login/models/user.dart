import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class User extends Equatable {
  final String username;
  final String password;
  final String team;

  const User({
    required this.username,
    required this.password,
    required this.team,
  });

  @override
  List<Object> get props => [username, password, team];

  static const User empty = User(
    username: '',
    password: '',
    team: '',
  );
}
