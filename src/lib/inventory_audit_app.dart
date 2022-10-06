import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_cbl_learning_path/app_view.dart';
import 'package:flutter_cbl_learning_path/features/audit/data/audit_repository.dart';
import 'package:flutter_cbl_learning_path/features/audit/data/stock_item_repository.dart';
import 'package:flutter_cbl_learning_path/features/drawer/data/user_repository.dart';
import 'package:flutter_cbl_learning_path/features/project/data/project_repository.dart';
import 'package:flutter_cbl_learning_path/features/project/data/warehouse_repository.dart';
import 'package:flutter_cbl_learning_path/features/project/services/warehouse_selected_service.dart';
import 'package:flutter_cbl_learning_path/features/audit/services/stock_item_selection_service.dart';
import 'package:flutter_cbl_learning_path/features/router/route.dart';
import 'package:flutter_cbl_learning_path/features/database/database.dart';

class InventoryAuditApp extends StatelessWidget {
  const InventoryAuditApp(
      {Key? key,
      required this.authService,
      required this.routerService,
      required this.warehouseSelectionService,
      required this.stockItemSelectionService,
      required this.databaseProvider,
      required this.projectRepository,
      required this.auditRepository,
      required this.stockItemRepository,
      required this.warehouseRepository,
      required this.userRepository})
      : super(key: key);

  final FakeAuthenticationService authService;
  final AppRouterService routerService;
  final WarehouseSelectionService warehouseSelectionService;
  final StockItemSelectionService stockItemSelectionService;
  final DatabaseProvider databaseProvider;
  final ProjectRepository projectRepository;
  final AuditRepository auditRepository;
  final StockItemRepository stockItemRepository;
  final WarehouseRepository warehouseRepository;
  final UserRepository userRepository;

  // This is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: authService),
          RepositoryProvider.value(value: routerService),
          RepositoryProvider.value(value: warehouseSelectionService),
          RepositoryProvider.value(value: stockItemSelectionService),
          RepositoryProvider.value(value: databaseProvider),
          RepositoryProvider.value(value: projectRepository),
          RepositoryProvider.value(value: auditRepository),
          RepositoryProvider.value(value: stockItemRepository),
          RepositoryProvider.value(value: warehouseRepository),
          RepositoryProvider.value(value: userRepository),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) =>
                  RouteBloc(authService, routerService, databaseProvider),
            ),
          ],
          child: const AppView(),
        ));
  }
}
