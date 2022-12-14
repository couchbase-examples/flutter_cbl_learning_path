import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:cbl/cbl.dart';

import 'package:flutter_cbl_learning_path/features/database/database.dart';
import 'package:flutter_cbl_learning_path/features/router/route.dart';
import 'package:flutter_cbl_learning_path/models/models.dart';

class AuditRepository {

  const AuditRepository(this._databaseProvider, this._authenticationService);

  final AuthenticationService _authenticationService;
  final DatabaseProvider _databaseProvider;
  final String auditDocumentType = 'audit';
  final String attributeDocumentType = 'documentType';

  Future<AsyncListenStream<QueryChange<ResultSet>>?>? getDocuments(String projectId) async {
    try {
      var user = await _authenticationService.getCurrentUser();
      var team = user?.team;
      if (team != null){
        var db = _databaseProvider.inventoryDatabase;
        if (db != null){
          // <1>
          var query = await AsyncQuery.fromN1ql(db, "SELECT * FROM _ AS item WHERE documentType=\"audit\" AND projectId=\$projectId AND team=\$team");

          //<2>
          var parameters = Parameters();
          parameters.setValue(projectId, name: "projectId");
          parameters.setValue(team, name: "team");

          //<3>
          await query.setParameters(parameters);
          return query.changes();
        }
      }
    } catch (e){
      debugPrint(e.toString());
    }
    return null;
  }

  Future<Audit> get(String projectId, String documentId) async {
    var now = DateTime.now();
    try {
     var db = _databaseProvider.inventoryDatabase;
     if (db != null){
       var doc = await db.document(documentId);
       if (doc != null){
         return Audit.fromJson(jsonDecode(doc.toJson()));
       }
     }
    }catch (e){
      debugPrint(e.toString());
    }
    return Audit(
      auditId: documentId,
      projectId: projectId,
      notes: '',
      auditCount: 0,
      stockItem: null,
      team: '',
      createdOn: now,
      modifiedOn: now,
      createdBy: '',
      modifiedBy: ''
    );
  }

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

  Future<bool> delete(String auditId) async  {
    try {
      var db = _databaseProvider.inventoryDatabase;
      if (db != null) {
        var doc = await db.document(auditId);
        if (doc != null) {
          return await db.deleteDocument(doc);
        }
      }
    }catch (e){
      debugPrint(e.toString());
    }
    return false;
  }
}
