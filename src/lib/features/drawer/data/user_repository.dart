import 'package:flutter/foundation.dart';
import 'package:cbl/cbl.dart';
import 'package:flutter_cbl_learning_path/features/database/database.dart';
import 'package:flutter_cbl_learning_path/features/router/service/auth_service.dart';

class UserRepository {
  const UserRepository(this._databaseProvider, this._authenticationService);
  final DatabaseProvider _databaseProvider;
  final AuthenticationService _authenticationService;

  final String documentType = "user";

  String getDatabaseName() => _databaseProvider.currentInventoryDatabaseName;
  String getDatabasePath() => _databaseProvider.getInventoryDatabasePath();

  Future<int> count() async {
    var count = 0;
    try {
      var attributeCount = 'count';
      var db = _databaseProvider.inventoryDatabase;
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

  Future<Map<String, Object?>> get() async {
    // <1>
    var documentId = await getCurrentUserDocumentId();
    try {
      // <2>
      var db = _databaseProvider.inventoryDatabase;
      // <3>
      if (db != null) {
        // <4>
        if (documentId.contains('@')) {
          // <5>
          var result = await db.document(documentId);
          // <6>
          if (result != null) {
            // <7>
            return result.toPlainMap();
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return <String, Object?>{'email': documentId.substring(6, documentId.length)};
  }

  Future<bool> save(Map<String, Object> document) async {
    try {
      var user = await _authenticationService.getCurrentUser();
      if (user != null && !document.containsKey('email')){
        document['email'] = user.username;
      }
      // <1>
      var db = _databaseProvider.inventoryDatabase;
      // <2>
      if (db != null) {
        // <3>
        var documentId = await getCurrentUserDocumentId();
        // <4>
        var mutableDocument = MutableDocument.withId(documentId, document);
        // <5>
        return await db.saveDocument(mutableDocument);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<String> getCurrentUserDocumentId() async {
    // <1>
    var user = await _authenticationService.getCurrentUser();
    // <2>
    return 'user::${user?.username}';
  }
}
