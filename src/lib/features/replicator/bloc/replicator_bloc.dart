import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cbl/cbl.dart';
import 'package:equatable/equatable.dart';

part 'replicator_event.dart';
part 'replicator_state.dart';

class ReplicatorBloc extends Bloc<ReplicatorEvent, ReplicatorState> {
  ReplicatorBloc() : super(const ReplicatorState()) {
    on<ReplicatorEvent>((event, emit) {
    });
  }
}
