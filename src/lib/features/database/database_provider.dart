import 'dart:io';
import 'dart:async';
import 'dart:isolate';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:cbl_flutter/cbl_flutter.dart';
import 'package:cbl/cbl.dart';
import 'package:archive/archive_io.dart';
import '../login/models/user.dart';
import 'package:flutter/foundation.dart';

import '../utils/file_system.dart';

class DatabaseProvider {
  //database information
  final String defaultInventoryDatabaseName = 'inventory';
  final String warehouseDatabaseName = 'warehouse';
  String currentInventoryDatabaseName = 'inventory';

  //index names
  final String documentTypeIndexName = 'idxDocumentType';
  final String documentTypeAttributeName = 'documentType';
  final String teamIndexName = 'idxTeam';
  final String teamAttributeName = 'team';
  final String cityIndexName = 'idxCity';
  final String cityAttributeName = 'city';
  final String cityStateIndexName = 'idxCityStateType';
  final String stateAttributeName = 'state';
  final String auditIndexName = 'idxAudit';
  final String projectIdAttributeName = 'projectId';

  //directory and file information
  String cblPreBuiltDatabasePath = "";
  String databaseFileName = "db.sqlite3";
  final String startingWarehouseDatabaseName = 'startingWarehouses';
  final String assetsDatabaseFileName = "asset/database/startingWarehouses.zip";
  late Directory cblLogsDirectory;
  late Directory cblDatabaseDirectory;

  //database pointers
  late final AsyncDatabase? inventoryDatabase;
  late final AsyncDatabase? warehouseDatabase;

  bool isInitalized = false;

  DatabaseProvider();

  Future<void> initialize() async {
    //init Couchbase Lite for use with databases
    if (!isInitalized) {
      isInitalized = true;
      await Future.wait([
        setupFileSystem(),
        CouchbaseLiteFlutter.init(),
      ]);
      //setup logging
      _setupCouchbaseLogging();
    }
  }

  /* setupFileSystem - used to calculate the path to save database and log files on the device */
  Future<void> setupFileSystem() async {
    final databaseDirectory = await getApplicationDocumentsDirectory();
    final logsDirectory = await getApplicationDocumentsDirectory();
    cblDatabaseDirectory = databaseDirectory.subDirectory('databases');
    cblLogsDirectory = logsDirectory.subDirectory('logs').subDirectory('cbl');
    cblPreBuiltDatabasePath =
        "${cblDatabaseDirectory.path}/$startingWarehouseDatabaseName.cblite2";
  }

  //setup and open the database file(s)
  Future<void> initDatabases({required User user}) async {
    try {
      var dbConfig =
          DatabaseConfiguration(directory: cblDatabaseDirectory.path);

      // create the warehouse database if it doesn't already exist
      // use Dart Concurrency:
      // https://dart.dev/guides/language/concurrency
      if (!File("$cblPreBuiltDatabasePath/$databaseFileName").existsSync()) {
        final unzipDatabaseRP = ReceivePort();
        await Isolate.spawn(_unzipPrebuiltDatabase, unzipDatabaseRP.sendPort);

        final copyDatabaseRP = ReceivePort();
        await Isolate.spawn(_copyWarehouseDatabase, copyDatabaseRP.sendPort);
      }
      //open the warehouse database
      warehouseDatabase =
          await Database.openAsync(warehouseDatabaseName, dbConfig);

      //calculate database name based on current logged in users team name
      final teamName = user.team.toLowerCase().trim();
      currentInventoryDatabaseName =
          "${teamName}_$defaultInventoryDatabaseName";

      /* create or open a database to share between team members to store
      projects, assets, and user profiles */
      inventoryDatabase =
          await Database.openAsync(currentInventoryDatabaseName, dbConfig);

      /* @biozal - 8/30/2022
       * tried to create these using Isolate.spawn but then I run into issue 
       * here: https://github.com/dart-lang/sdk/issues/36983 
       * for now will just call using standard async, but really this should be 
       * spawned into a seperate process to stop frames from being dropped
       */

      //create indexes for queries
      await _createDocumentTypeIndex();
      await _createTeamDocumentTypeIndex();
      await _createCityDocumentTypeIndex();
      await _createCityStateDocumentTypeIndex();
      await _createAuditIndex();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _copyWarehouseDatabase(SendPort sendPort) async {
    //create database config
    var dbConfig = DatabaseConfiguration(directory: cblDatabaseDirectory.path);

    // you MUST copy the prebuilt database to the warehouse database
    // never open a prebuilt database directly as this will cause issues
    // with sync
    Database.copy(
        from: cblPreBuiltDatabasePath,
        name: warehouseDatabaseName,
        config: dbConfig);

    Isolate.exit(sendPort);
  }

  /* _unzipPrebuiltDatabase - unzip the prebuilt database included in the asset/database folder to the application database directory */
  Future<void> _unzipPrebuiltDatabase(SendPort sendPort) async {
    //get the prebuild database zip file back from asset folder
    var pbdbWarehousesZip = await rootBundle.load(assetsDatabaseFileName);

    if (pbdbWarehousesZip.lengthInBytes > 0) {
      //decompress the zip file into a bytes and then convert into a List which is required by the Archive framework
      final archive =
          ZipDecoder().decodeBytes(pbdbWarehousesZip.buffer.asUint8List());

      //loop through directory and files in the zip file and create them
      for (final file in archive) {
        final fileName = file.name;
        if (file.isFile) {
          final fileData = file.content as List<int>;
          File('${cblDatabaseDirectory.path}/$fileName')
            ..createSync(recursive: true)
            ..writeAsBytesSync(fileData);
        } else {
          Directory(cblDatabaseDirectory.path).createSync(recursive: true);
        }
      }
    }
    Isolate.exit(sendPort);
  }

  /* closeDatabases - close the databases */
  Future<void> closeDatabases() async {
    await inventoryDatabase?.close();
    await warehouseDatabase?.close();
  }

  Future<void> _createDocumentTypeIndex() async {
    final expression = Expression.property(documentTypeAttributeName);
    final valueIndexItems = {ValueIndexItem.expression(expression)};
    final index = IndexBuilder.valueIndex(valueIndexItems);

    //copy to local per working with nullable fields
    //https://dart.dev/null-safety/understanding-null-safety#working-with-nullable-fields
    var warehouseDb = warehouseDatabase;
    if (warehouseDb != null) {
      final indexes = await warehouseDb.indexes;
      if (!(indexes.contains(documentTypeIndexName))) {
        await warehouseDb.createIndex(documentTypeIndexName, index);
      }
    }
    var inventoryDb = inventoryDatabase;
    if (inventoryDb != null) {
      final indexes = await inventoryDb.indexes;
      if (!(indexes.contains(documentTypeIndexName))) {
        await inventoryDb.createIndex(documentTypeIndexName, index);
      }
    }
  }

  Future<void> _createTeamDocumentTypeIndex() async {
    final documentTypeExpression =
        Expression.property(documentTypeAttributeName);
    final teamExpression = Expression.property(teamAttributeName);
    final valueIndexItems = {
      ValueIndexItem.expression(documentTypeExpression),
      ValueIndexItem.expression(teamExpression)
    };
    final index = IndexBuilder.valueIndex(valueIndexItems);
    var inventoryDb = inventoryDatabase;
    if (inventoryDb != null) {
      final indexes = await inventoryDb.indexes;
      if (!(indexes.contains(teamIndexName))) {
        await inventoryDb.createIndex(teamIndexName, index);
      }
    }
  }

  Future<void> _createCityDocumentTypeIndex() async {
    final documentTypeExpression =
        Expression.property(documentTypeAttributeName);
    final cityExpression = Expression.property(cityAttributeName);
    final valueIndexItems = {
      ValueIndexItem.expression(documentTypeExpression),
      ValueIndexItem.expression(cityExpression)
    };
    final index = IndexBuilder.valueIndex(valueIndexItems);
    var inventoryDb = inventoryDatabase;
    if (inventoryDb != null) {
      final indexes = await inventoryDb.indexes;
      if (!(indexes.contains(cityIndexName))) {
        await inventoryDb.createIndex(cityIndexName, index);
      }
    }
  }

  Future<void> _createCityStateDocumentTypeIndex() async {
    final documentTypeExpression =
        Expression.property(documentTypeAttributeName);
    final cityExpression = Expression.property(cityAttributeName);
    final stateExpression = Expression.property(stateAttributeName);
    final valueIndexItems = {
      ValueIndexItem.expression(documentTypeExpression),
      ValueIndexItem.expression(cityExpression),
      ValueIndexItem.expression(stateExpression),
    };
    final index = IndexBuilder.valueIndex(valueIndexItems);
    var inventoryDb = inventoryDatabase;
    if (inventoryDb != null) {
      final indexes = await inventoryDb.indexes;
      if (!(indexes.contains(cityStateIndexName))) {
        await inventoryDb.createIndex(cityStateIndexName, index);
      }
    }
  }

  Future<void> _createAuditIndex() async {
    final documentTypeExpression =
        Expression.property(documentTypeAttributeName);
    final projectIdExpression = Expression.property(projectIdAttributeName);
    final teamExpression = Expression.property(teamAttributeName);
    final valueIndexItems = {
      ValueIndexItem.expression(documentTypeExpression),
      ValueIndexItem.expression(projectIdExpression),
      ValueIndexItem.expression(teamExpression),
    };
    final index = IndexBuilder.valueIndex(valueIndexItems);
    var inventoryDb = inventoryDatabase;
    if (inventoryDb != null) {
      final indexes = await inventoryDb.indexes;
      if (!(indexes.contains(auditIndexName))) {
        await inventoryDb.createIndex(auditIndexName, index);
      }
    }
  }

  /* _setupCouchbaseLogging - For Flutter apps `Database.log.custom` is setup with a logger, which logs to `print`, but only at log level `warning`. */
  void _setupCouchbaseLogging() {
    //use for dev builds only!!
    Database.log.custom!.level = LogLevel.verbose;
    Database.log.file.config = LogFileConfiguration(
        directory: cblLogsDirectory.path, usePlainText: true);
  }
}
