import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cbl/cbl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cbl_learning_path/features/project/bloc/project_list_event.dart';
import 'package:flutter_cbl_learning_path/features/project/bloc/project_list_state.dart';
import 'package:flutter_cbl_learning_path/features/project/data/project_repository.dart';

import '../../../models/models.dart';
import '../../../models/project_dao.dart';

class ProjectListBloc extends Bloc<ProjectListEvent, ProjectListState> {
  ProjectListBloc({required ProjectRepository repository})
      : _repository = repository,
        super(const ProjectListState()) {
    on<ProjectListInitializeEvent>(_onInitialize);
    on<ProjectListLoadedEvent>(_onLoaded);

  }

  final ProjectRepository _repository;
  AsyncListenStream<QueryChange<ResultSet>>? _liveQueryStream;

  var isInitialState = true;

  @override
  Future<void> close() async {
    super.close();
    _liveQueryStream = null;
  }

  Future<void> _onLoaded(
      ProjectListLoadedEvent event, Emitter<ProjectListState> emit) async {

    var items = event.items;

    //if first time loading, then return loaded status, otherwise return changed status
    //this allows UI to react better to changes vs initial load and allows building
    //of a better user experience

    // <1>
    if (items.isNotEmpty && isInitialState){
      isInitialState = false;
      emit(state.copyWith(status: DataStatus.loaded, items: items, error: ''));
    // <2>
    } else if (items.isNotEmpty && !isInitialState){
      emit(state.copyWith(status: DataStatus.changed, items: items, error: ''));
    // <3>
    } else {
      emit(state.copyWith(status: DataStatus.empty));
    }
  }

  Future<void> _onInitialize (
      ProjectListInitializeEvent event, Emitter<ProjectListState> emit) async {
    try {
      if (_liveQueryStream == null) {
        // <1>
        _liveQueryStream = await _repository.getDocuments();
        // <2>
        if (_liveQueryStream != null) {
          // <3>
          var stream = _liveQueryStream;
          emit(state.copyWith(status: DataStatus.loading));
          // <4>
          stream?.listen((change) async {
            // <5>
            var items = <Project>[];
            // <6>
            var results = await change.results.allResults();
            // <7>
            for (var result in results) {
              // <8>
              var map = result.toPlainMap();
              var dao = ProjectDao.fromJson(map);
              // <9>
              items.add(dao.item);
            }
            // <10>
            if (!isClosed)
            {
              add(ProjectListLoadedEvent(items: items));
            }

          });
          //await stream?.listening;
        }
      }
    }
    catch (e) {
      emit(state.copyWith(status: DataStatus.error, error: e.toString()));
      debugPrint(e.toString());
    }
  }
}
