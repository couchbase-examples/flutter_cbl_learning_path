import 'dart:io';
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
  final String stateIndexName = 'idxCityStateType';
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
  late final AsyncDatabase? _inventoryDatabase;
  late final AsyncDatabase? _warehouseDatabase;

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
      if (!File("$cblPreBuiltDatabasePath/$databaseFileName").existsSync()) {
        await _unzipPrebuiltDatabase();

        // you MUST copy the prebuilt database to the warehouse database
        // never open a prebuilt database directly as this will cause issues
        // with sync
        Database.copy(
            from: cblPreBuiltDatabasePath,
            name: warehouseDatabaseName,
            config: dbConfig);
      }
      //open the warehouse database
      _warehouseDatabase =
          await Database.openAsync(warehouseDatabaseName, dbConfig);

      //calculate database name based on current logged in users team name
      final teamName = user.team.toLowerCase().trim();
      currentInventoryDatabaseName =
          "${teamName}_$defaultInventoryDatabaseName";

      /* create or open a database to share between team members to store
      projects, assets, and user profiles */
      _inventoryDatabase =
          await Database.openAsync(currentInventoryDatabaseName, dbConfig);

      //create indexes for queries

    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /* _unzipPrebuiltDatabase - unzip the prebuilt database included in the asset/database folder to the application database directory */
  Future<void> _unzipPrebuiltDatabase() async {
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
  }

  /* closeDatabases - close the databases */
  void closeDatabases() {
    _inventoryDatabase?.close();
    _warehouseDatabase?.close();
  }

  /* _setupCouchbaseLogging - For Flutter apps `Database.log.custom` is setup with a logger, which logs to `print`, but only at log level `warning`. */
  void _setupCouchbaseLogging() {
    //use for dev builds only!!
    Database.log.custom!.level = LogLevel.verbose;
    Database.log.file.config = LogFileConfiguration(
        directory: cblLogsDirectory.path, usePlainText: true);
  }
}
