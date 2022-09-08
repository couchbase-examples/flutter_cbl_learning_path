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
  String documentType = "project";
  DateTime? dueDate;
  Warehouse? warehouse;

  //security tracking
  String team;
  String createdBy;
  String modifiedBy;
  DateTime? createdOn;
  DateTime? modifiedOn;

  Project(
      this.projectId,
      this.name,
      this.description,
      this.isComplete,
      this.dueDate,
      this.warehouse,
      this.team,
      this.createdBy,
      this.createdOn,
      this.modifiedBy,
      this.modifiedOn);
  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
