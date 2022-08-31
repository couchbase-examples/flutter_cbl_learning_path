// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockItem _$StockItemFromJson(Map<String, dynamic> json) => StockItem(
      json['itemId'] as String,
      json['name'] as String,
      (json['price'] as num).toDouble(),
      json['description'] as String,
      json['style'] as String,
    )..documentType = json['documentType'] as String;

Map<String, dynamic> _$StockItemToJson(StockItem instance) => <String, dynamic>{
      'itemId': instance.itemId,
      'name': instance.name,
      'price': instance.price,
      'description': instance.description,
      'style': instance.style,
      'documentType': instance.documentType,
    };
