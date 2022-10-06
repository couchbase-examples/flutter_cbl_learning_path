import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:cbl/cbl.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter_cbl_learning_path/features/audit/data/audit_repository.dart';
import 'package:flutter_cbl_learning_path/features/audit/data/stock_item_repository.dart';
import 'package:flutter_cbl_learning_path/features/project/data/warehouse_repository.dart';
import 'package:flutter_cbl_learning_path/features/database/database.dart';
import 'package:flutter_cbl_learning_path/features/router/route.dart';
import 'package:flutter_cbl_learning_path/models/models.dart';

class ProjectRepository {
  final DatabaseProvider _databaseProvider;
  final StockItemRepository _stockItemRepository;
  final WarehouseRepository _warehouseRepository;
  final AuditRepository _auditRepository;
  final AuthenticationService _authenticationService;

  final String projectDocumentType = 'project';
  final String auditDocumentType = 'audit';
  final String attributeDocumentType = 'documentType';

  const ProjectRepository(
      this._databaseProvider,
      this._authenticationService,
      this._auditRepository,
      this._warehouseRepository,
      this._stockItemRepository);

  String getDatabaseName() => _databaseProvider.currentInventoryDatabaseName;

  String getDatabasePath() => _databaseProvider.getInventoryDatabasePath();

  Future<AsyncListenStream<QueryChange<ResultSet>>?>? getDocuments() async {
    try {
      var user = await _authenticationService.getCurrentUser();
      var team = user?.team;
      if (team != null) {
        var db = _databaseProvider.inventoryDatabase;
        if (db != null) {
          var query = QueryBuilder.createAsync()
              .select(SelectResult.all())
              .from(DataSource.database(db).as('item'))
              .where(Expression.property(attributeDocumentType)
                  .equalTo(Expression.string(projectDocumentType))
                  .and(Expression.property('team')
                      .equalTo(Expression.string(team)))); // <1>
          return query.changes();
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<int> count() async {
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
        projectId: documentId,
        name: "",
        description: "",
        isComplete: false,
        dueDate: dueDate,
        warehouse: null,
        team: "",
        createdBy: "",
        createdOn: now,
        modifiedBy: "",
        modifiedOn: now);
  }

  Future<bool> save(Project document) async {
    try {
      var db = _databaseProvider.inventoryDatabase;
      if (db != null) {
        Map<String, dynamic> map = document.toJson();
        var doc = MutableDocument.withId(document.projectId, map);
        var result = await db.saveDocument(doc);
        debugPrint(
            'Did save project ${document.projectId} resulted in ${result.toString()}');
        return true;
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

  Future<bool> updateWarehouse(String projectId, Warehouse warehouse) async {
    try {
      var project = await get(projectId);
      project.warehouse = warehouse;
      await save(project);
      return true;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<void> loadSampleData() async {
    var currentUser = await _authenticationService.getCurrentUser();
    var warehouses = await _warehouseRepository.get();
    var stockItems = await _stockItemRepository.get();

    //won't create items if we can't get warehouse and stock items from prebuilt warehouse database
    if (warehouses.isNotEmpty && stockItems.isNotEmpty) {
      var db = _databaseProvider.inventoryDatabase;
      if (db != null) {
        /* batch operations for saving multiple documents is a faster way to process
        groups of documents at once */
        db.inBatch(() async {
          // <1>
          //create 12 new projects with random data
          var uuid = const Uuid();
          final random = Random();
          const minYear = 2022;
          const maxYear = 2025;
          const minMonth = 1;
          const maxMonth = 12;
          const minDay = 1;
          const maxDay = 28;
          var date = DateTime.now();
          //create 12 new projects with random data
          for (var projectIndex = 0; projectIndex <= 11; projectIndex++) {
            // <2>
            //get data items to create project
            String projectId = uuid.v4();
            var warehouse = warehouses[projectIndex]; // <3>
            var yearRandom = minYear + random.nextInt(maxYear - minYear);
            var monthRandom = minMonth + random.nextInt(maxMonth - minMonth);
            var dayRandom = minDay + random.nextInt(maxDay - minDay);
            var dueDate = DateTime.utc(yearRandom, monthRandom, dayRandom);
            //create project
            var projectDocument = Project(
                //<4>
                projectId: projectId,
                name: '${warehouse.name} Audit',
                description:
                    'Audit of warehouse stock located in ${warehouse.city}, ${warehouse.state}.',
                isComplete: false,
                dueDate: dueDate,
                warehouse: warehouse,
                team: currentUser!.team,
                createdBy: currentUser.username,
                createdOn: date,
                modifiedBy: currentUser.username,
                modifiedOn: date);
            var didSave = await save(projectDocument); // <5>
            if (didSave) {
              // <6>
              //create random audit counts per project // <7>
              for (var auditIndex = 0; auditIndex <= 49; auditIndex++) {
                var auditId = uuid.v4();
                var stockCount = 1 + random.nextInt(10000 - 1);
                var stockItemIndex = random.nextInt(stockItems.length);
                var stockItem = stockItems[stockItemIndex];
                var auditDocument = Audit(
                    auditId: auditId,
                    projectId: projectId,
                    stockItem: stockItem,
                    auditCount: stockCount,
                    notes:
                        'Found item ${stockItem.name} - ${stockItem.description} in warehouse',
                    team: currentUser.team,
                    createdBy: currentUser.username,
                    modifiedBy: currentUser.username,
                    createdOn: date,
                    modifiedOn: date);
                await _auditRepository.save(auditDocument);
              }
            }
          }
        });
      }
    }
  }
}
