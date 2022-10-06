import 'package:json_annotation/json_annotation.dart';
import './audit.dart';

/// This allows the `AuditDao` class to access private members in
/// the generated file.
/// See:  https://docs.flutter.dev/development/data-and-backend/json#creating-model-classes-the-json_serializable-way
///

part 'audit_dao.g.dart';

@JsonSerializable(explicitToJson: true)
class AuditDao {
  const AuditDao(this.item);
  final Audit item;

  factory AuditDao.fromJson(Map<String, dynamic> json) =>
      _$AuditDaoFromJson(json);

  Map<String, dynamic> toJson() => _$AuditDaoToJson(this);
}
