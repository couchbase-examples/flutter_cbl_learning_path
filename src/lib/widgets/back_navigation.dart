import 'package:flutter/material.dart';
import 'package:flutter_cbl_learning_path/features/router/route.dart';

abstract class BackNavigationStatelessWidget extends StatelessWidget {
  final AppRouterService routerService;
  const BackNavigationStatelessWidget({super.key, required this.routerService});

  Future<bool> onBackPressed() {
    routerService.routeTo(ScreenRoute(routeToScreen: RouteToScreen.pop));
    return Future.value(false);
  }
}
