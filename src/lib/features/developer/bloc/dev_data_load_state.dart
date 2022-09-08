import 'package:equatable/equatable.dart';

enum DevDataLoadStatus { uninitialized, loading, success, failed }

class DevDataLoadState extends Equatable {
  const DevDataLoadState(
      {this.status = DevDataLoadStatus.uninitialized, this.error = ''});

  final DevDataLoadStatus status;
  final String error;

  DevDataLoadState copyWith(DevDataLoadStatus? status, String? error) {
    return DevDataLoadState(
        status: status ?? this.status, error: error ?? this.error);
  }

  @override
  List<Object> get props => [status, error];

  @override
  String toString() => 'Status:  $status, error: $error}';
}
