part of 'replicator_bloc.dart';

abstract class ReplicatorEvent extends Equatable {
  const ReplicatorEvent();

  @override
  List<Object?> get props => [];
}

class ReplicatorStopEvent extends ReplicatorEvent {
  const ReplicatorStopEvent();
}

class ReplicatorStartEvent extends ReplicatorEvent {
  const ReplicatorStartEvent();
}

class ReplicatorClearLogsEvent extends ReplicatorEvent{
  const ReplicatorClearLogsEvent();
}

class ReplicatorUpdateDocumentLogEvent extends ReplicatorEvent{
  const ReplicatorUpdateDocumentLogEvent();
}

class ReplicatorUpdateStatusLogEvent extends ReplicatorEvent{
  const ReplicatorUpdateStatusLogEvent();
}