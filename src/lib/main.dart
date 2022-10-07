import 'package:flutter/material.dart';
import 'package:flutter_cbl_learning_path/features/audit/data/audit_repository.dart';
import 'package:flutter_cbl_learning_path/features/audit/data/stock_item_repository.dart';
import 'package:flutter_cbl_learning_path/features/drawer/data/user_repository.dart';
import 'package:flutter_cbl_learning_path/features/project/data/project_repository.dart';
import 'package:flutter_cbl_learning_path/features/project/data/warehouse_repository.dart';
import 'package:flutter_cbl_learning_path/features/project/services/warehouse_selected_service.dart';
import 'package:flutter_cbl_learning_path/features/audit/services/stock_item_selection_service.dart';
import 'package:flutter_cbl_learning_path/inventory_audit_app.dart';
import 'package:flutter_cbl_learning_path/features/router/route.dart';
import 'package:flutter_cbl_learning_path/features/database/database_provider.dart';

import 'features/database/replicator_provider.dart';

void main() {
  //define global providers and services
  var dbProvider = DatabaseProvider();
  var authService = FakeAuthenticationService();
  var warehouseSelectionService = WarehouseSelectionService();
  var stockItemSelectionService = StockItemSelectionService();

  //setup repositories
  var stockItemRepository = StockItemRepository(dbProvider);
  var warehouseRepository = WarehouseRepository(dbProvider);
  var auditRepository = AuditRepository(dbProvider, authService);
  var projectRepository = ProjectRepository(dbProvider, authService,
      auditRepository, warehouseRepository, stockItemRepository);
  var userRepository = UserRepository(dbProvider, authService);

  //setup replication provider
  var replicationProvider = ReplicatorProvider(authenticationService: authService, databaseProvider: dbProvider);

  runApp(InventoryAuditApp(
    authService: authService,
    routerService: AppRouterService(),
    warehouseSelectionService: warehouseSelectionService,
    stockItemSelectionService: stockItemSelectionService,
    databaseProvider: dbProvider,
    replicatorProvider: replicationProvider,
    projectRepository: projectRepository,
    auditRepository: auditRepository,
    stockItemRepository: stockItemRepository,
    warehouseRepository: warehouseRepository,
    userRepository: userRepository,
  ));
}
