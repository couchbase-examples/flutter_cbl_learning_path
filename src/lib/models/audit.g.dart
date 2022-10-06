// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Audit _$AuditFromJson(Map<String, dynamic> json) => Audit(
      auditId: json['auditId'] as String,
      projectId: json['projectId'] as String,
      stockItem: json['stockItem'] == null
          ? null
          : StockItem.fromJson(json['stockItem'] as Map<String, dynamic>),
      auditCount: json['auditCount'] as int,
      notes: json['notes'] as String,
      team: json['team'] as String,
      createdBy: json['createdBy'] as String,
      modifiedBy: json['modifiedBy'] as String,
      createdOn: json['createdOn'] == null
          ? null
          : DateTime.parse(json['createdOn'] as String),
      modifiedOn: json['modifiedOn'] == null
          ? null
          : DateTime.parse(json['modifiedOn'] as String),
    )..documentType = json['documentType'] as String;

Map<String, dynamic> _$AuditToJson(Audit instance) => <String, dynamic>{
      'auditId': instance.auditId,
      'projectId': instance.projectId,
      'stockItem': instance.stockItem?.toJson(),
      'auditCount': instance.auditCount,
      'notes': instance.notes,
      'documentType': instance.documentType,
      'team': instance.team,
      'createdBy': instance.createdBy,
      'modifiedBy': instance.modifiedBy,
      'createdOn': instance.createdOn?.toIso8601String(),
      'modifiedOn': instance.modifiedOn?.toIso8601String(),
    };
