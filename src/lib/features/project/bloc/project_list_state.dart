import 'package:equatable/equatable.dart';
import 'package:flutter_cbl_learning_path/models/models.dart';

class ProjectListState extends Equatable {
  const ProjectListState(
      {this.status = DataStatus.uninitialized,
      this.items = const <Project>[],
      this.error = ''});

  final DataStatus status;
  final List<Project> items;
  final String error;

  ProjectListState copyWith({
    DataStatus? status,
    List<Project>? items,
    String? error,
  }) {
    return ProjectListState(
        status: status ?? this.status,
        items: items ?? this.items,
        error: error ?? this.error);
  }

  @override
  List<Object> get props => [status, items, error];
}
