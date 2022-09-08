import 'package:json_annotation/json_annotation.dart';
import './warehouse.dart';

/// This allows the `WarehouseDao` class to access private members in
/// the generated file.
/// See:  https://docs.flutter.dev/development/data-and-backend/json#creating-model-classes-the-json_serializable-way
///

part 'warehouse_dao.g.dart';

@JsonSerializable(explicitToJson: true)
class WarehouseDao {
  final Warehouse warehouse;
  const WarehouseDao(this.warehouse);

  factory WarehouseDao.fromJson(Map<String, dynamic> json) =>
      _$WarehouseDaoFromJson(json);

  Map<String, dynamic> toJson() => _$WarehouseDaoToJson(this);
}
