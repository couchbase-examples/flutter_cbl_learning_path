import 'package:flutter/foundation.dart';
import 'package:cbl/cbl.dart';

import 'package:flutter_cbl_learning_path/features/database/database.dart';
import 'package:flutter_cbl_learning_path/models/models.dart';

class AuditRepository {
  final DatabaseProvider _databaseProvider;
  final String auditDocumentType = 'audit';
  final String attributeDocumentType = 'documentType';

  const AuditRepository(this._databaseProvider);

  Future<int> count() async {
    var count = 0;
    try {
      var attributeCount = 'count';

      var db = _databaseProvider.inventoryDatabase;
      if (db != null) {
        var query = await AsyncQuery.fromN1ql(db,
            'SELECT COUNT(*) AS count FROM _ AS item WHERE documentType="$auditDocumentType"'); // <1>
        var result = await query.execute(); // <2>
        var results = await result.allResults(); // <3>
        count = results.first.integer(attributeCount); // <4>
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return count;
  }

  Future<bool> save(Audit document) async {
    try {
      var db = _databaseProvider.inventoryDatabase;
      if (db != null) {
        Map<String, dynamic> map = document.toJson();
        var doc = MutableDocument.withId(document.auditId, map);
        var result = await db.saveDocument(doc);
        debugPrint(
            'Did save audit ${document.auditId} resulted in ${result.toString()}');
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }
}
