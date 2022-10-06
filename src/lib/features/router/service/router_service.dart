import 'dart:async';

import '../../../models/models.dart';
import '../../audit/bloc/audit_list_bloc.dart';

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

class ScreenRoute{
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
