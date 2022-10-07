part of 'replicator_bloc.dart';

abstract class ReplicatorEvent extends Equatable {
  const ReplicatorEvent();

  @override
  List<Object?> get props => [];
}

class ReplicatorStop extends ReplicatorEvent {
  const ReplicatorStop();
}

class ReplicatorStart extends ReplicatorEvent {
  const ReplicatorStart();
}

class ReplicatorClearLogs extends ReplicatorEvent{
  const ReplicatorClearLogs();
}
