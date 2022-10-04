import 'package:json_annotation/json_annotation.dart';
import 'warehouse.dart';

/// This allows the `Project` class to access private members in
/// the generated file.
/// See:  https://docs.flutter.dev/development/data-and-backend/json#creating-model-classes-the-json_serializable-way
part 'project.g.dart';

@JsonSerializable(explicitToJson: true)
class Project {
  String projectId;
  String name;
  String description;
  bool isComplete;
  String documentType = 'project';
  DateTime? dueDate;
  Warehouse? warehouse;

  //security tracking
  String team;
  String createdBy;
  String modifiedBy;
  DateTime? createdOn;
  DateTime? modifiedOn;

  Project( {
    required this.projectId,
    required this.name,
    required this.description,
    required this.isComplete,
    required this.dueDate,
    required this.warehouse,
    required this.team,
    required this.createdBy,
    required this.createdOn,
    required this.modifiedBy,
    required this.modifiedOn});

  String dueDateToString() {
    var date = dueDate;
    if (date != null) {
      return '${date.month}/${date.day}/${date.year}';
    }
    return '';
  }
  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
