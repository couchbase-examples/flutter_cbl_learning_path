import 'package:equatable/equatable.dart';

import '../../../models/project.dart';

abstract class ProjectListEvent extends Equatable{
  const ProjectListEvent();

  @override
  List<Object> get props => [];
}

class ProjectListInitializeEvent extends ProjectListEvent {
  const ProjectListInitializeEvent();
}

class ProjectListLoadedEvent extends ProjectListEvent {
  const ProjectListLoadedEvent({required this.items});

  final List<Project> items;

  @override
  List<Object> get props => [items];
}

