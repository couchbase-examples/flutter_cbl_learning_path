import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:cbl/cbl.dart';

import 'package:flutter_cbl_learning_path/features/database/database.dart';
import 'package:flutter_cbl_learning_path/models/models.dart';

class ProjectRepository {
  final DatabaseProvider _databaseProvider;
  final String projectDocumentType = 'project';
  final String auditDocumentType = 'audit';
  final String attributeDocumentType = 'documentType';

  const ProjectRepository(this._databaseProvider);

  String getDatabaseName() => _databaseProvider.currentInventoryDatabaseName;

  Future<int> getCount() async {
    var count = 0;
    try {
      var attributeCount = 'count';

      var db = _databaseProvider.inventoryDatabase;
      if (db != null) {
        var query = QueryBuilder.createAsync()
            .select(
                SelectResult.expression(Function_.count(Expression.string("*")))
                    .as(attributeCount))
            .from(DataSource.database(db))
            .where(Expression.property(attributeDocumentType)
                .equalTo(Expression.string(projectDocumentType))); // <1>

        var result = await query.execute(); // <2>
        var results = await result.allResults(); // <3>
        count = results.first.integer(attributeCount); // <4>
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return count;
  }

  Future<Project> get(String documentId) async {
    var now = DateTime.now();
    var dueDate = DateTime(now.year, now.month + 3, now.day);
    try {
      var db = _databaseProvider.inventoryDatabase;
      if (db != null) {
        var doc = await db.document(documentId);
        if (doc != null) {
          return Project.fromJson(jsonDecode(doc.toJson()));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return Project(
        documentId, "", "", false, dueDate, null, "", "", now, "", now);
  }

  Future<bool> save(Project document) async {
    try {
      var db = _databaseProvider.inventoryDatabase;
      if (db != null) {
        Map<String, dynamic> map = document.toJson();
        var doc = MutableDocument.withId(document.projectId, map);
        return await db.saveDocument(doc);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<bool> delete(String documentId) async {
    try {
      var db = _databaseProvider.inventoryDatabase;
      if (db != null) {
        var doc = await db.document(documentId);
        if (doc != null) {
          return await db.deleteDocument(doc);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }
}
