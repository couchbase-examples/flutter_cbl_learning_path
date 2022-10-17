import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cbl/cbl.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cbl_learning_path/features/database/replicator_provider.dart';

part 'replicator_event.dart';
part 'replicator_state.dart';

class ReplicatorBloc extends Bloc<ReplicatorEvent, ReplicatorState> {
  ReplicatorBloc(ReplicatorProvider replicatorProvider) :
        _replicatorProvider = replicatorProvider,
        super(const ReplicatorState()) {
    on<ReplicatorStopEvent>(_onReplicatorStop);
    on<ReplicatorStartEvent>(_onReplicatorStart);
    on<ReplicatorClearLogsEvent>(_onReplicatorClearLogs);
  }

  final ReplicatorProvider _replicatorProvider;

  FutureOr<void> _onReplicatorStop(
      ReplicatorStopEvent event,
      Emitter<ReplicatorState> emit) async {
    try {
      emit(const ReplicatorState.stopping());
      await _replicatorProvider.stopReplicator();
      emit(const ReplicatorState.stopped());
    } catch(e){
      debugPrint('${DateTime.now()} [ReplicatorBloc] error: trying to stop replicator, received error - ${e.toString()}.');
    }
  }

  FutureOr<void> _onReplicatorStart(
      ReplicatorStartEvent event,
      Emitter<ReplicatorState> emit) async {
    try {
      emit(const ReplicatorState.starting());
      _replicatorProvider.startReplicator(onStatusChange: onStatusChange, onDocument: onDocument);
      emit(const ReplicatorState.started());
    } catch(e){
      debugPrint('${DateTime.now()} [ReplicatorBloc] error: trying to start replicator, received error - ${e.toString()}.');
    }
  }

  onStatusChange(ReplicatorChange change) {
    var status = change.status.activity.name;
  }

  onDocument(DocumentReplication document) {

  }

  FutureOr<void> _onReplicatorClearLogs(
      ReplicatorClearLogsEvent event,
      Emitter<ReplicatorState> emit) async {
  }
}
