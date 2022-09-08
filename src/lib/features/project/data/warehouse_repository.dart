import 'package:flutter/foundation.dart';
import 'package:cbl/cbl.dart';

import 'package:flutter_cbl_learning_path/features/database/database.dart';
import 'package:flutter_cbl_learning_path/models/models.dart';

class WarehouseRepository {
  final DatabaseProvider _databaseProvider;
  final String documentType = 'warehouse';

  final String cityAttributeName = 'city';
  final String stateAttributeName = 'state';
  final String attributeDocumentType = 'documentType';
  final String itemAliasName = 'item';

  const WarehouseRepository(this._databaseProvider);

  String getDatabaseName() => _databaseProvider.warehouseDatabaseName;
  String getDatabasePath() => _databaseProvider.getWarehouseDatabasePath();

  Future<int> count() async {
    var count = 0;
    try {
      var attributeCount = 'count';

      var db = _databaseProvider.warehouseDatabase;
      if (db != null) {
        var query = QueryBuilder.createAsync()
            .select(
                SelectResult.expression(Function_.count(Expression.string("*")))
                    .as(attributeCount))
            .from(DataSource.database(db))
            .where(Expression.property(attributeDocumentType)
                .equalTo(Expression.string(documentType))); // <1>

        var result = await query.execute(); // <2>
        var results = await result.allResults(); // <3>
        count = results.first.integer(attributeCount); // <4>
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return count;
  }

  Future<List<Warehouse>> get() async {
    List<Warehouse> items = [];
    try {
      var db = _databaseProvider.warehouseDatabase;
      if (db != null) {
        var query = QueryBuilder.createAsync()
            .select(SelectResult.all())
            .from(DataSource.database(db).as('warehouse'))
            .where(Expression.property(attributeDocumentType)
                .equalTo(Expression.string(documentType)));

        var result = await query.execute();
        var results = await result.allResults();
        for (var r in results) {
          var map = r.toPlainMap();
          var warehouseDoa = WarehouseDao.fromJson(map);
          items.add(warehouseDoa.warehouse);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return items;
  }
}
