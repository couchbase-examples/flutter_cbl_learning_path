// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_item_dao.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockItemDao _$StockItemDaoFromJson(Map<String, dynamic> json) => StockItemDao(
      StockItem.fromJson(json['item'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StockItemDaoToJson(StockItemDao instance) =>
    <String, dynamic>{
      'item': instance.item.toJson(),
    };
