// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warehouse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Warehouse _$WarehouseFromJson(Map<String, dynamic> json) => Warehouse(
      json['warehouseId'] as String,
      json['name'] as String,
      json['address1'] as String,
      json['address2'] as String,
      json['city'] as String,
      json['state'] as String,
      json['postalCode'] as String,
      json['salesTax'] as String,
      (json['yearToDateBalance'] as num).toDouble(),
      (json['latitude'] as num).toDouble(),
      (json['longitude'] as num).toDouble(),
      (json['shippingTo'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$WarehouseToJson(Warehouse instance) => <String, dynamic>{
      'warehouseId': instance.warehouseId,
      'name': instance.name,
      'address1': instance.address1,
      'address2': instance.address2,
      'city': instance.city,
      'state': instance.state,
      'postalCode': instance.postalCode,
      'salesTax': instance.salesTax,
      'yearToDateBalance': instance.yearToDateBalance,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'shippingTo': instance.shippingTo,
    };
