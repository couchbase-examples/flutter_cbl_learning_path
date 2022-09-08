import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_cbl_learning_path/features/project/data/project_repository.dart';
import './dev_data_load_event.dart';
import './dev_data_load_state.dart';

class DevDataLoadBloc extends Bloc<DevDataLoadEvent, DevDataLoadState> {
  final ProjectRepository _projectRepository;

  DevDataLoadBloc({
    required ProjectRepository projectRepository,
  })  : _projectRepository = projectRepository,
        super(const DevDataLoadState(
            status: DevDataLoadStatus.uninitialized, error: '')) {
    on<DevDataLoadEvent>(_initialize);
  }

  Future<void> _initialize(
      DevDataLoadEvent event, Emitter<DevDataLoadState> emit) async {
    try {
      //start loading data into collection
      emit(const DevDataLoadState(status: DevDataLoadStatus.loading));
      //call the data loader
      await _projectRepository.loadSampleData();

      //validate that we added some projects
      var projectCount = await _projectRepository.count();
      if (projectCount > 0) {
        emit(const DevDataLoadState(
            status: DevDataLoadStatus.success, error: ''));
      } else {
        emit(const DevDataLoadState(
            status: DevDataLoadStatus.failed,
            error:
                'Project Count is still zero so no projects were added.  Please check logs for more information on what failed.'));
      }
    } catch (e) {
      var error = state.copyWith(DevDataLoadStatus.failed, e.toString());
      emit(error);
      debugPrint(e.toString());
    }
  }
}
