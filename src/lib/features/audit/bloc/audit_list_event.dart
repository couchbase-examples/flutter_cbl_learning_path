import 'package:equatable/equatable.dart';

import '../../../models/audit.dart';

abstract class AuditListEvent extends Equatable {
  const AuditListEvent();

  @override
  List<Object> get props => [];
}

class AuditListInitializeEvent extends AuditListEvent {
  const AuditListInitializeEvent({required this.projectId});

  final String projectId;

  @override
  List<Object> get props => [projectId];
}

class AuditListLoadedEvent extends AuditListEvent {
  const AuditListLoadedEvent({required this.items});

  final List<Audit> items;

  @override
  List<Object> get props => [items];
}