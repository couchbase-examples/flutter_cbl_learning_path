import 'package:equatable/equatable.dart';
import 'package:flutter_cbl_learning_path/models/form_status.dart';
import '../../../models/warehouse.dart';

class ProjectEditorState extends Equatable {
  const ProjectEditorState(
      {this.status = FormEditorStatus.dataUninitialized,
      this.name = '',
      this.description = '',
      this.dueDate = 'Select Due Date',
      this.error = '',
      this.warehouse});

  final FormEditorStatus status;
  final String name;
  final String description;
  final String dueDate;
  final String error;

  final Warehouse? warehouse;

  ProjectEditorState copyWith(
      {FormEditorStatus? status,
      String? name,
      String? description,
      String? dueDate,
      String? error,
      Warehouse? warehouse}) {
    return ProjectEditorState(
        status: status ?? this.status,
        name: name ?? this.name,
        description: description ?? this.description,
        dueDate: dueDate ?? this.dueDate,
        error: error ?? this.error,
        warehouse: warehouse ?? this.warehouse);
  }

  @override
  List<Object?> get props =>
      [status, name, description, dueDate, error, warehouse];
}
