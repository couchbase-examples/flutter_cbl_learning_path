import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cbl_learning_path/features/audit/services/stock_item_selection_service.dart';

import '../../../models/models.dart';
import '../../../widgets/back_navigation.dart';
import '../../router/service/auth_service.dart';
import '../../router/service/router_service.dart';
import '../bloc/audit_editor_bloc.dart';
import '../data/audit_repository.dart';
import 'audit_editor_form.dart';

class AuditEditorScreen extends BackNavigationStatelessWidget {
  const AuditEditorScreen({super.key, required super.routerService});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Set<ScreenRoute>;
    var routeScreen = args.first;

    var audit = routeScreen.audit;
    var projectId = routeScreen.projectId as String;

    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Audit Editor'),
        ),
        backgroundColor: Colors.white,
        body: BlocProvider(
          create: (context) {
            return AuditEditorBloc(
                auditRepository:
                    RepositoryProvider.of<AuditRepository>(context),
                authenticationService:
                    RepositoryProvider.of<FakeAuthenticationService>(context),
                routerService: RepositoryProvider.of<AppRouterService>(context),
                stockItemSelectionService:
                    RepositoryProvider.of<StockItemSelectionService>(context),
              audit: audit,
              projectId: projectId);
          },
          child: const AuditEditorForm(),
        ),
      ),
    );
  }
}
