import 'package:equatable/equatable.dart';
import 'package:flutter_cbl_learning_path/models/models.dart';

class AuditListState extends Equatable {
  const AuditListState(
      {this.status = DataStatus.uninitialized,
        this.items = const <Audit>[],
        this.error = ''});

  final DataStatus status;
  final List<Audit> items;
  final String error;

  AuditListState copyWith({
    DataStatus? status,
    List<Audit>? items,
    String? error,
  }) {
    return AuditListState(
        status: status ?? this.status,
        items: items ?? this.items,
        error: error ?? this.error);
  }

  @override
  List<Object> get props => [status, items, error];
}
