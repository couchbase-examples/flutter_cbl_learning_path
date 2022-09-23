import 'package:json_annotation/json_annotation.dart';
import './project.dart';

/// This allows the `ProjectDao` class to access private members in
/// the generated file.
/// See:  https://docs.flutter.dev/development/data-and-backend/json#creating-model-classes-the-json_serializable-way
///

part 'project_dao.g.dart';

@JsonSerializable(explicitToJson: true)
class ProjectDao{
  const ProjectDao(this.item);
  final Project item;

  factory ProjectDao.fromJson(Map<String, dynamic> json) => _$ProjectDaoFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectDaoToJson(this);
}