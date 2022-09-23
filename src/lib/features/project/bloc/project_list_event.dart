import 'package:equatable/equatable.dart';

import '../../../models/project.dart';

abstract class ProjectListEvent extends Equatable{
  const ProjectListEvent();

  @override
  List<Object> get props => [];
}

class ProjectListInitializeEvent extends ProjectListEvent {
  const ProjectListInitializeEvent();

  @override
  List<Object> get props => [];
}

class ProjectListLoadedEvent extends ProjectListEvent {
  const ProjectListLoadedEvent({required this.projects});

  final List<Project> projects;

  @override
  List<Object> get props => [projects];
}

