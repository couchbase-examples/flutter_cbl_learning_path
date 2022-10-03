import 'package:json_annotation/json_annotation.dart';

/// This allows the `Warehouse` class to access private members in
/// the generated file.
/// See:  https://docs.flutter.dev/development/data-and-backend/json#creating-model-classes-the-json_serializable-way

part 'warehouse.g.dart';

@JsonSerializable(explicitToJson: true)
class Warehouse {
  final String warehouseId;
  final String name;
  final String address1;
  final String? address2;
  final String city;
  final String state;
  final String postalCode;
  final double salesTax;
  final double yearToDateBalance;
  final double latitude;
  final double longitude;
  final List<String>? shippingTo;
  final String documentType = "warehouse";

  const Warehouse(
      this.warehouseId,
      this.name,
      this.address1,
      this.address2,
      this.city,
      this.state,
      this.postalCode,
      this.salesTax,
      this.yearToDateBalance,
      this.latitude,
      this.longitude,
      this.shippingTo);

  @override
  String toString(){
    return name;
  }

  factory Warehouse.fromJson(Map<String, dynamic> json) =>
      _$WarehouseFromJson(json);

  Map<String, dynamic> toJson() => _$WarehouseToJson(this);
}
