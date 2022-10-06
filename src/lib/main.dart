import 'package:flutter/material.dart';
import 'package:flutter_cbl_learning_path/features/audit/data/audit_repository.dart';
import 'package:flutter_cbl_learning_path/features/audit/data/stock_item_repository.dart';
import 'package:flutter_cbl_learning_path/features/drawer/data/user_repository.dart';
import 'package:flutter_cbl_learning_path/features/project/data/project_repository.dart';
import 'package:flutter_cbl_learning_path/features/project/data/warehouse_repository.dart';
import 'package:flutter_cbl_learning_path/features/project/services/warehouse_selected_service.dart';
import 'package:flutter_cbl_learning_path/features/audit/services/stock_item_selection_service.dart';
import './inventory_audit_app.dart';
import 'features/router/route.dart';
import 'features/database/database_provider.dart';

void main() {
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

  runApp(InventoryAuditApp(
    authService: authService,
    routerService: AppRouterService(),
    warehouseSelectionService: warehouseSelectionService,
    stockItemSelectionService: stockItemSelectionService,
    databaseProvider: dbProvider,
    projectRepository: projectRepository,
    auditRepository: auditRepository,
    stockItemRepository: stockItemRepository,
    warehouseRepository: warehouseRepository,
    userRepository: userRepository,
  ));
}
