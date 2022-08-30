import 'dart:async';

enum RouteToScreen {
  developer,
  developerInfo,
  projects,
  projectEditor,
  warehouseSelector,
  audits,
  auditEditor,
  itemSelector,
  replicator,
  replicatorConfig,
  logout,
  none,
  pop,
}

abstract class RouterService {
  Stream<RouteToScreen> get route;
  void routeTo(RouteToScreen route);
}

class AppRouterService extends RouterService {
  final _controller = StreamController<RouteToScreen>();

  AppRouterService();

  void dispose() => _controller.close();

  @override
  void routeTo(RouteToScreen route) {
    _controller.add(route);
  }

  @override
  Stream<RouteToScreen> get route async* {
    yield RouteToScreen.none;
    yield* _controller.stream;
  }
}
