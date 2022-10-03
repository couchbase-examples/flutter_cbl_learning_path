import 'package:flutter/foundation.dart';
import 'package:cbl/cbl.dart';

import 'package:flutter_cbl_learning_path/features/database/database.dart';
import 'package:flutter_cbl_learning_path/models/models.dart';

class WarehouseRepository {

  const WarehouseRepository(this._databaseProvider);

  final DatabaseProvider _databaseProvider;
  final String documentType = 'warehouse';

  final String cityAttributeName = 'city';
  final String stateAttributeName = 'state';
  final String attributeDocumentType = 'documentType';
  final String itemAliasName = 'item';

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

  Future<List<Warehouse>> search(String searchCity, String? searchState) async {
    List<Warehouse> items = [];
    try {
      var db = _databaseProvider.warehouseDatabase;
      if (db != null) {
        // <1>
        var whereExpression = Function_.lower(Expression.property(attributeDocumentType)).equalTo(Expression.string(documentType));
        // <2>
        var cityExpression = Function_.lower(Expression.property(cityAttributeName))
                                .like(Expression.string("%${searchCity.toLowerCase()}%"));
        whereExpression = whereExpression.and(cityExpression);

        // <3>
        if(searchState != null && searchState.isNotEmpty){
          var stateExpression = Function_.lower(Expression.property(stateAttributeName))
              .like(Expression.string("%${searchState.toLowerCase()}%"));
          whereExpression = whereExpression.and(stateExpression);
        }

        // <4>
        var query = QueryBuilder.createAsync()
            .select(SelectResult.all())
            .from(DataSource.database(db).as('warehouse'))
            .where(whereExpression);

        // <5>
        var result = await query.execute();
        var results = await result.allResults();

        // <6>
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
