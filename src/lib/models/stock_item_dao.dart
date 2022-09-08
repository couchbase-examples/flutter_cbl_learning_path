import 'package:json_annotation/json_annotation.dart';
import './stock_item.dart';

/// This allows the `StockItemDao` class to access private members in
/// the generated file.
/// See:  https://docs.flutter.dev/development/data-and-backend/json#creating-model-classes-the-json_serializable-way
///
part 'stock_item_dao.g.dart';

@JsonSerializable(explicitToJson: true)
class StockItemDao {
  final StockItem item;
  const StockItemDao(this.item);
  factory StockItemDao.fromJson(Map<String, dynamic> json) =>
      _$StockItemDaoFromJson(json);

  Map<String, dynamic> toJson() => _$StockItemDaoToJson(this);
}
