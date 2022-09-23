import 'package:bloc/bloc.dart';
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
  var isInitialState = true;

  Future<void> _onLoaded(
      ProjectListLoadedEvent event, Emitter<ProjectListState> emit) async {

    var items = event.projects;

    //if first time loading, then return loaded status, otherwise return changed status
    //this allows UI to react better to changes vs initial load and allows building
    //of a better user experience

    // <1>
    if (items.isNotEmpty && isInitialState){
      isInitialState = false;
      emit(state.copyWith(status: DataStatus.loaded, projects: items, error: ''));
    // <2>
    } else if (items.isNotEmpty && !isInitialState){
      emit(state.copyWith(status: DataStatus.changed, projects: items, error: ''));
    // <3>
    } else {
      emit(state.copyWith(status: DataStatus.empty));
    }
  }


  Future<void> _onInitialize (
      ProjectListInitializeEvent event, Emitter<ProjectListState> emit) async {
    try {
      emit(state.copyWith(status: DataStatus.loading));
      // <1>
      var stream = await _repository.getDocuments();
      // <2>
      if (stream != null) {
        // <3>
        stream.listen((change) async {
          // <4>
          var items = <Project>[];
          // <5>
          var results = await change.results.allResults();
          //<6>
          for (var result in results) {
            // <7>
            var map = result.toPlainMap();
            var dao = ProjectDao.fromJson(map);
            // <8>
            items.add(dao.item);
          }
          // <9>
          add(ProjectListLoadedEvent(projects: items));
        });
      }
    } catch (e) {
      emit(state.copyWith(status: DataStatus.error, error: e.toString()));
      debugPrint(e.toString());
    }
  }
}
