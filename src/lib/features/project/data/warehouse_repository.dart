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
      const attributeCount = 'count';

      final db = _databaseProvider.warehouseDatabase;
      if (db != null) {
        final query = QueryBuilder.createAsync()
            .select(
                SelectResult.expression(Function_.count(Expression.all()))
                    .as(attributeCount))
            .from(DataSource.database(db))
            .where(Expression.property(attributeDocumentType)
                .equalTo(Expression.string(documentType))); // <1>

        final result = await query.execute(); // <2>
        final results = await result.allResults(); // <3>
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
      final db = _databaseProvider.warehouseDatabase;
      if (db != null) {
        final query = QueryBuilder.createAsync()
            .select(SelectResult.all())
            .from(DataSource.database(db).as('warehouse'))
            .where(Expression.property(attributeDocumentType)
            .equalTo(Expression.string(documentType)));

        final result = await query.execute();
        final results = await result.allResults();
        for (var r in results) {
          r.toJson();
          final map = r.toPlainMap();
          final warehouseDoa = WarehouseDao.fromJson(map);
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
      final db = _databaseProvider.warehouseDatabase;
      if (db != null) {
        // <1>
        var whereExpression = Function_.lower(
            Expression.property(attributeDocumentType)).equalTo(
            Expression.string(documentType));
        // <2>
        final cityExpression = Function_.lower(
            Expression.property(cityAttributeName))
            .like(Expression.string("%${searchCity.toLowerCase()}%"));
        whereExpression = whereExpression.and(cityExpression);

        // <3>
        if (searchState != null && searchState.isNotEmpty) {
          final stateExpression = Function_.lower(
              Expression.property(stateAttributeName))
              .like(Expression.string("%${searchState.toLowerCase()}%"));
          whereExpression = whereExpression.and(stateExpression);
        }

        // <4>
        final query = QueryBuilder.createAsync()
            .select(SelectResult.all())
            .from(DataSource.database(db).as('warehouse'))
            .where(whereExpression);

        // <5>
        final result = await query.execute();
        final results = await result.allResults();

        // <6>
        for (var r in results) {
          final map = r.toPlainMap();
          final warehouseDoa = WarehouseDao.fromJson(map);
          items.add(warehouseDoa.warehouse);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return items;
  }
}
