import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cbl_learning_path/features/audit/data/audit_repository.dart';
import 'package:flutter_cbl_learning_path/features/audit/data/stock_item_repository.dart';
import 'package:flutter_cbl_learning_path/features/project/data/project_repository.dart';
import 'package:flutter_cbl_learning_path/features/project/data/warehouse_repository.dart';
import 'package:flutter_cbl_learning_path/features/router/route.dart';
import 'package:flutter_cbl_learning_path/features/database/database.dart';
import './app_view.dart';

class InventoryAuditApp extends StatelessWidget {
  final FakeAuthenticationService authService;
  final AppRouterService routerService;
  final DatabaseProvider databaseProvider;
  final ProjectRepository projectRepository;
  final AuditRepository auditRepository;
  final StockItemRepository stockItemRepository;
  final WarehouseRepository warehouseRepository;

  const InventoryAuditApp(
      {Key? key,
      required this.authService,
      required this.routerService,
      required this.databaseProvider,
      required this.projectRepository,
      required this.auditRepository,
      required this.stockItemRepository,
      required this.warehouseRepository})
      : super(key: key);

  // This is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: authService),
          RepositoryProvider.value(value: routerService),
          RepositoryProvider.value(value: databaseProvider),
          RepositoryProvider.value(value: projectRepository),
          RepositoryProvider.value(value: auditRepository),
          RepositoryProvider.value(value: stockItemRepository),
          RepositoryProvider.value(value: warehouseRepository),
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
