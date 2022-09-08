import 'package:flutter/foundation.dart';
import 'package:cbl/cbl.dart';

import 'package:flutter_cbl_learning_path/features/database/database.dart';
import 'package:flutter_cbl_learning_path/models/models.dart';

import '../../../models/stock_item_dao.dart';

class StockItemRepository {
  final DatabaseProvider _databaseProvider;
  final String documentType = 'item';

  final String cityAttributeName = 'city';
  final String stateAttributeName = 'state';
  final String attributeDocumentType = 'documentType';
  final String itemAliasName = 'item';

  const StockItemRepository(this._databaseProvider);

  Future<int> count() async {
    var count = 0;
    try {
      var attributeCount = 'count';

      var db = _databaseProvider.warehouseDatabase;
      if (db != null) {
        var query = await AsyncQuery.fromN1ql(db,
            'SELECT COUNT(*) AS count FROM _ AS item WHERE documentType="$documentType"'); // <1>
        var result = await query.execute(); // <2>
        var results = await result.allResults(); // <3>
        count = results.first.integer(attributeCount); // <4>
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return count;
  }

  Future<List<StockItem>> get() async {
    List<StockItem> items = [];
    try {
      var db = _databaseProvider.warehouseDatabase;
      if (db != null) {
        var query = await AsyncQuery.fromN1ql(
            db, 'SELECT * FROM _ AS item WHERE documentType="$documentType"');
        var result = await query.execute();
        var results = await result.allResults();
        for (var r in results) {
          var map = r.toPlainMap();
          var stockItemDao = StockItemDao.fromJson(map);
          items.add(stockItemDao.item);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return items;
  }
}
