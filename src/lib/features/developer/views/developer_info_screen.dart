import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cbl_learning_path/features/audit/data/audit_repository.dart';
import 'package:flutter_cbl_learning_path/features/audit/data/stock_item_repository.dart';
import 'package:flutter_cbl_learning_path/features/project/data/project_repository.dart';
import 'package:flutter_cbl_learning_path/features/project/data/warehouse_repository.dart';
import 'package:flutter_cbl_learning_path/features/router/service/auth_service.dart';
import 'package:flutter_cbl_learning_path/widgets/back_navigation.dart';
import '../developer_info.dart';
import 'developer_info_widget.dart';

class DeveloperInfoScreen extends BackNavigationStatelessWidget {
  const DeveloperInfoScreen({super.key, required super.routerService});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Developer Information'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(2),
          child: BlocProvider(
              create: (context) {
                return DevInfoBloc(
                  authenticationService:
                      RepositoryProvider.of<FakeAuthenticationService>(context),
                  projectRepository:
                      RepositoryProvider.of<ProjectRepository>(context),
                  warehouseRepository:
                      RepositoryProvider.of<WarehouseRepository>(context),
                  auditRepository:
                      RepositoryProvider.of<AuditRepository>(context),
                  stockItemRepository:
                      RepositoryProvider.of<StockItemRepository>(context),
                  //call add to have it get data right away
                )..add(DevInfoGetDataEvent());
              },
              child: const DeveloperInfoWidget()),
        ),
      ),
    );
  }
}
