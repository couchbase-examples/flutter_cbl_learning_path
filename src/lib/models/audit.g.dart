// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Audit _$AuditFromJson(Map<String, dynamic> json) => Audit(
      json['auditId'] as String,
      json['projectId'] as String,
      StockItem.fromJson(json['stockItem'] as Map<String, dynamic>),
      json['auditCount'] as int,
      json['notes'] as String,
      json['team'] as String,
      json['createdBy'] as String,
      json['modifiedBy'] as String,
      json['createdOn'] == null
          ? null
          : DateTime.parse(json['createdOn'] as String),
      json['modifiedOn'] == null
          ? null
          : DateTime.parse(json['modifiedOn'] as String),
    );

Map<String, dynamic> _$AuditToJson(Audit instance) => <String, dynamic>{
      'auditId': instance.auditId,
      'projectId': instance.projectId,
      'stockItem': instance.stockItem,
      'auditCount': instance.auditCount,
      'notes': instance.notes,
      'team': instance.team,
      'createdBy': instance.createdBy,
      'modifiedBy': instance.modifiedBy,
      'createdOn': instance.createdOn?.toIso8601String(),
      'modifiedOn': instance.modifiedOn?.toIso8601String(),
    };
