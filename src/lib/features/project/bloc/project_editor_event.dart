import 'package:equatable/equatable.dart';
import 'package:flutter_cbl_learning_path/models/models.dart';

abstract class ProjectEditorEvent extends Equatable{
  const ProjectEditorEvent();

  @override
  List<Object?> get props => [];
}

class ProjectEditorNameChangedEvent extends ProjectEditorEvent {
  const ProjectEditorNameChangedEvent(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class ProjectEditorDescriptionChangedEvent extends ProjectEditorEvent {
  const ProjectEditorDescriptionChangedEvent(this.description);

  final String description;

  @override
  List<Object> get props => [description];
}

class ProjectEditorDueDateChangeEvent extends ProjectEditorEvent {
  const ProjectEditorDueDateChangeEvent(this.dueDate);

  final Future<DateTime?> dueDate;

  @override
  List<Object?> get props => [dueDate];
}

class ProjectEditorDueDateChangedEvent extends ProjectEditorEvent{
  const ProjectEditorDueDateChangedEvent(this.dateSelected);

  final String dateSelected;

  @override
  List<Object> get props => [dateSelected];
}

class ProjectEditorWarehouseChangedEvent extends ProjectEditorEvent {
  const ProjectEditorWarehouseChangedEvent();
}

class ProjectEditorSaveEvent extends ProjectEditorEvent{
  const ProjectEditorSaveEvent();
}

class ProjectEditorInitialProjectLoadingEvent extends ProjectEditorEvent{
  const ProjectEditorInitialProjectLoadingEvent(this.projectId);
  final String projectId;

  @override
  List<Object> get props => [projectId];
}

class ProjectEditorInitialProjectLoadedEvent extends ProjectEditorEvent{
  const ProjectEditorInitialProjectLoadedEvent(this.project);
  final Project project;

  @override
  List<Object> get props => [project];
}
