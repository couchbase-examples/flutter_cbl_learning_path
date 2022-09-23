import 'package:equatable/equatable.dart';
import 'package:flutter_cbl_learning_path/models/models.dart';

class ProjectListState extends Equatable {
  const ProjectListState(
      {this.status = DataStatus.uninitialized,
      this.projects = const <Project>[],
      this.error = ''});

  final DataStatus status;
  final List<Project> projects;
  final String error;

  ProjectListState copyWith({
    DataStatus? status,
    List<Project>? projects,
    String? error,
  }) {
    return ProjectListState(
        status: status ?? this.status,
        projects: projects ?? this.projects,
        error: error ?? this.error);
  }

  @override
  List<Object> get props => [status, projects, error];
}
