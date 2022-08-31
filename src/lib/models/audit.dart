import 'package:json_annotation/json_annotation.dart';
import 'stock_item.dart';

/// This allows the `Audit` class to access private members in
/// the generated file.
/// See:  https://docs.flutter.dev/development/data-and-backend/json#creating-model-classes-the-json_serializable-way

part 'audit.g.dart';

@JsonSerializable()
class Audit {
  String auditId;
  String projectId;
  StockItem stockItem;
  int auditCount;
  String notes;

  //security tracking
  String team;
  String createdBy;
  String modifiedBy;
  DateTime? createdOn;
  DateTime? modifiedOn;

  Audit(
      this.auditId,
      this.projectId,
      this.stockItem,
      this.auditCount,
      this.notes,
      this.team,
      this.createdBy,
      this.modifiedBy,
      this.createdOn,
      this.modifiedOn);
  factory Audit.fromJson(Map<String, dynamic> json) => _$AuditFromJson(json);

  Map<String, dynamic> toJson() => _$AuditToJson(this);
}
