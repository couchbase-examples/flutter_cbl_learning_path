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
      final user = await _authenticationService.getCurrentUser();
      final team = user?.team;
      if (team != null) {
        final db = _databaseProvider.inventoryDatabase;
        if (db != null) {
          final query = QueryBuilder.createAsync() //<1>
              .select(SelectResult.all())  // <2>
              .from(DataSource.database(db).as('item')) //<3>
              .where(Expression.property(attributeDocumentType)
                  .equalTo(Expression.string(projectDocumentType))
                  .and(Expression.property('team')
                      .equalTo(Expression.string(team)))); // <4>
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
      const attributeCount = 'count';

      final db = _databaseProvider.inventoryDatabase;
      if (db != null) {
        final query = QueryBuilder.createAsync()
            .select(
                SelectResult.expression(Function_.count(Expression.string("*")))
                    .as(attributeCount))
            .from(DataSource.database(db))
            .where(Expression.property(attributeDocumentType)
                .equalTo(Expression.string(projectDocumentType))); // <1>
        final result = await query.execute(); // <2>
        final results = await result.allResults(); // <3>
        count = results.first.integer(attributeCount); // <4>
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return count;
  }

  Future<Project> get(String documentId) async {
    final now = DateTime.now();
    final dueDate = DateTime(now.year, now.month + 3, now.day);
    try {
      final db = _databaseProvider.inventoryDatabase;
      if (db != null) {
        final doc = await db.document(documentId);
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
      final db = _databaseProvider.inventoryDatabase;
      if (db != null) {
        Map<String, dynamic> map = document.toJson();
        final doc = MutableDocument.withId(document.projectId, map);
        final result = await db.saveDocument(doc);
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
      final db = _databaseProvider.inventoryDatabase;
      if (db != null) {
        final doc = await db.document(documentId);
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
      final project = await get(projectId);
      project.warehouse = warehouse;
      await save(project);
      return true;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<void> loadSampleData() async {
    final currentUser = await _authenticationService.getCurrentUser();
    final warehouses = await _warehouseRepository.get();
    final stockItems = await _stockItemRepository.get();

    //won't create items if we can't get warehouse and stock items from prebuilt warehouse database
    if (warehouses.isNotEmpty && stockItems.isNotEmpty) {
      final db = _databaseProvider.inventoryDatabase;
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
          final date = DateTime.now();
          //create 12 new projects with random data
          for (var projectIndex = 0; projectIndex <= 11; projectIndex++) {
            // <2>
            //get data items to create project
            String projectId = uuid.v4();
            final warehouse = warehouses[projectIndex]; // <3>
            final yearRandom = minYear + random.nextInt(maxYear - minYear);
            final monthRandom = minMonth + random.nextInt(maxMonth - minMonth);
            final dayRandom = minDay + random.nextInt(maxDay - minDay);
            final dueDate = DateTime.utc(yearRandom, monthRandom, dayRandom);
            //create project
            final projectDocument = Project(
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
            final didSave = await save(projectDocument); // <5>
            if (didSave) {
              // <6>
              //create random audit counts per project // <7>
              for (var auditIndex = 0; auditIndex <= 49; auditIndex++) {
                final auditId = uuid.v4();
                final stockCount = 1 + random.nextInt(10000 - 1);
                final stockItemIndex = random.nextInt(stockItems.length);
                final stockItem = stockItems[stockItemIndex];
                final auditDocument = Audit(
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
