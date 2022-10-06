import 'dart:async';
import 'package:flutter_cbl_learning_path/features/audit/bloc/audit_list.dart';
import 'package:flutter_cbl_learning_path/models/models.dart';

enum RouteToScreen {
  developer,
  developerInfo,
  projects,
  projectEditor,
  warehouseSelector,
  audits,
  auditEditor,
  itemSelector,
  userProfileEditor,
  replicator,
  replicatorConfig,
  logout,
  none,
  pop,
}

class ScreenRoute {
  const ScreenRoute({
    required this.routeToScreen,
    this.projectId = '',
    this.auditId = '',
    this.project,
    this.audit,
    this.auditListBloc,
  });

  final RouteToScreen routeToScreen;
  final String? projectId;
  final String? auditId;
  final Audit? audit;
  final Project? project;
  final AuditListBloc? auditListBloc;
}

abstract class RouterService {
  Stream<ScreenRoute> get route;
  void routeTo(ScreenRoute route);
}

class AppRouterService extends RouterService {
  final _controller = StreamController<ScreenRoute>();

  AppRouterService();

  void dispose() => _controller.close();

  @override
  void routeTo(ScreenRoute route) {
    _controller.add(route);
  }

  @override
  Stream<ScreenRoute> get route async* {
    yield const ScreenRoute(routeToScreen: RouteToScreen.none);
    yield* _controller.stream;
  }
}
