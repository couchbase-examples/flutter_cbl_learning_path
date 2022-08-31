// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
      json['projectId'] as String,
      json['name'] as String,
      json['description'] as String,
      json['isComplete'] as bool,
      json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      json['warehouse'] == null
          ? null
          : Warehouse.fromJson(json['warehouse'] as Map<String, dynamic>),
      json['team'] as String,
      json['createdBy'] as String,
      json['createdOn'] == null
          ? null
          : DateTime.parse(json['createdOn'] as String),
      json['modifiedBy'] as String,
      json['modifiedOn'] == null
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
      'warehouse': instance.warehouse,
      'team': instance.team,
      'createdBy': instance.createdBy,
      'modifiedBy': instance.modifiedBy,
      'createdOn': instance.createdOn?.toIso8601String(),
      'modifiedOn': instance.modifiedOn?.toIso8601String(),
    };
