part of 'replicator_bloc.dart';

enum ReplicatorStateStatus{
  documentsUpdate,
  started,
  starting,
  stopped,
  stopping,
  statusUpdate,
  unknown,
}

class ReplicatorState extends Equatable {

  const ReplicatorState({this.replicatorStatus = ReplicatorStateStatus.unknown, this.changes, this.documents });

  const ReplicatorState.starting()
      : this(replicatorStatus: ReplicatorStateStatus.starting);

  const ReplicatorState.started()
      : this(replicatorStatus: ReplicatorStateStatus.started);

  const ReplicatorState.stopping()
      : this(replicatorStatus: ReplicatorStateStatus.stopping);

  const ReplicatorState.stopped()
      : this(replicatorStatus: ReplicatorStateStatus.stopped);

  const ReplicatorState.statusUpdate(List<String> changes)
      : this(replicatorStatus: ReplicatorStateStatus.statusUpdate,changes: changes);

  const ReplicatorState.documentsUpdate(List<String> documents)
      : this(replicatorStatus: ReplicatorStateStatus.statusUpdate, documents: documents);

  final ReplicatorStateStatus replicatorStatus;
  final List<String>? documents;
  final List<String>? changes;

  @override
  List<Object?> get props => [replicatorStatus, documents, changes];
}
