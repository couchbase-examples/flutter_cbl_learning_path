import 'package:equatable/equatable.dart';
import 'package:flutter_cbl_learning_path/features/login/login.dart';
import 'package:flutter_cbl_learning_path/features/developer/models/dev_info.dart';

enum DevInfoStatus { uninitialized, success, fail, loading }

class DevInfoState extends Equatable {
  const DevInfoState(
      {this.status = DevInfoStatus.uninitialized,
      this.items = const [],
      this.user = const User(username: '', password: '', team: ''),
      this.error = ''});

  final List<DeveloperInfo> items;
  final User user;
  final DevInfoStatus status;
  final String error;

  DevInfoState copyWith(DevInfoStatus? status, List<DeveloperInfo>? items,
      User? user, String? error) {
    return DevInfoState(
        status: status ?? this.status,
        error: error ?? this.error,
        user: user ?? this.user,
        items: items ?? this.items);
  }

  @override
  List<Object> get props => [items, user, status, error];

  @override
  String toString() =>
      'Status:  $status, error: $error, user: $user, items: ${items.length}';
}
