import 'package:json_annotation/json_annotation.dart';

/// This allows the `StockItem` class to access private members in
/// the generated file.
/// See:  https://docs.flutter.dev/development/data-and-backend/json#creating-model-classes-the-json_serializable-way

part 'stock_item.g.dart';

@JsonSerializable(explicitToJson: true)
class StockItem {
  String itemId;
  String name;
  double price;
  String description;
  String style;
  String documentType = "item";

  StockItem(this.itemId, this.name, this.price, this.description, this.style);

  factory StockItem.fromJson(Map<String, dynamic> json) =>
      _$StockItemFromJson(json);

  Map<String, dynamic> toJson() => _$StockItemToJson(this);
}
