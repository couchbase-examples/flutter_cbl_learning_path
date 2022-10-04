// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
      projectId: json['projectId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      isComplete: json['isComplete'] as bool,
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      warehouse: json['warehouse'] == null
          ? null
          : Warehouse.fromJson(json['warehouse'] as Map<String, dynamic>),
      team: json['team'] as String,
      createdBy: json['createdBy'] as String,
      createdOn: json['createdOn'] == null
          ? null
          : DateTime.parse(json['createdOn'] as String),
      modifiedBy: json['modifiedBy'] as String,
      modifiedOn: json['modifiedOn'] == null
          ? null
          : DateTime.parse(json['modifiedOn'] as String),
    )..documentType = json['documentType'] as String;

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'projectId': instance.projectId,
      'name': instance.name,
      'description': instance.description,
      'isComplete': instance.isComplete,
      'documentType': instance.documentType,
      'dueDate': instance.dueDate?.toIso8601String(),
      'warehouse': instance.warehouse?.toJson(),
      'team': instance.team,
      'createdBy': instance.createdBy,
      'modifiedBy': instance.modifiedBy,
      'createdOn': instance.createdOn?.toIso8601String(),
      'modifiedOn': instance.modifiedOn?.toIso8601String(),
    };
