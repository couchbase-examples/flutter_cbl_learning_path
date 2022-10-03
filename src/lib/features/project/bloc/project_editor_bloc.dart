import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';

import 'package:flutter_cbl_learning_path/features/project/bloc/project_editor_event.dart';
import 'package:flutter_cbl_learning_path/features/project/bloc/project_editor_state.dart';
import 'package:flutter_cbl_learning_path/features/project/data/project_repository.dart';
import 'package:flutter_cbl_learning_path/models/form_status.dart';


class ProjectEditorBloc extends Bloc<ProjectEditorEvent, ProjectEditorState> {
  ProjectEditorBloc({required ProjectRepository projectRepository})
      : _projectRepository = projectRepository,
        super(const ProjectEditorState()) {
    on<ProjectEditorNameChangedEvent>(_onNameChanged);
    on<ProjectEditorDescriptionChangedEvent>(_onDescriptionChanged);
    on<ProjectEditorDueDateChangeEvent>(_onDueDateChange);
    on<ProjectEditorDueDateChangedEvent>(_onDueDateChanged);
    on<ProjectEditorWarehouseChangedEvent>(_onWarehouseChanged);
    on<ProjectEditorInitialProjectLoadingEvent>(_onInitialization);
  }

  final ProjectRepository _projectRepository;

  FutureOr<void> _onNameChanged(
      ProjectEditorNameChangedEvent event, Emitter<ProjectEditorState> emit) {
    emit(state.copyWith(name: event.name, status: FormEditorStatus.dataChanged));
  }

  FutureOr<void> _onDescriptionChanged(ProjectEditorDescriptionChangedEvent event,
      Emitter<ProjectEditorState> emit) {
    emit(state.copyWith(name: event.description, status: FormEditorStatus.dataChanged));
  }

  Future<void> _onDueDateChange  (
      ProjectEditorDueDateChangeEvent event, Emitter<ProjectEditorState> emit) async {
    var dateSelected = await event.dueDate;
    if (dateSelected != null) {
      final DateFormat formatter = DateFormat("yyyy-MM-dd");
      add(ProjectEditorDueDateChangedEvent(formatter.format(dateSelected)));
    }
  }

  FutureOr<void> _onDueDateChanged(
      ProjectEditorDueDateChangedEvent event,
      Emitter<ProjectEditorState> emit) {
    emit(state.copyWith(dueDate: event.dateSelected, status: FormEditorStatus.dataChanged));
  }

  FutureOr<void> _onWarehouseChanged(
      ProjectEditorWarehouseChangedEvent event, Emitter<ProjectEditorState> emit) {
  }

  FutureOr<void> _onInitialization(ProjectEditorInitialProjectLoadingEvent event,
      Emitter<ProjectEditorState> emit) async {
    try {
      final project = await _projectRepository.get(event.projectId);
      if (project.name.isNotEmpty) {
        emit(state.copyWith(
            status: FormEditorStatus.dataLoaded,
            name: project.name,
            description: project.description,
            dueDate: project.dueDateToString(),
            warehouse: project.warehouse));
      }
    } catch (e) {
      emit(state.copyWith(status: FormEditorStatus.error, error: e.toString()));
      debugPrint(e.toString());
    }
  }
}
