import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cbl_learning_path/features/router/route.dart';
import './app_view.dart';

class InventoryAuditApp extends StatelessWidget {
  final FakeAuthenticationService authService;
  final AppRouterService routerService;

  const InventoryAuditApp(
      {Key? key, required this.authService, required this.routerService})
      : super(key: key);

  // This is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: authService),
          RepositoryProvider.value(value: routerService),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => RouteBloc(authService, routerService),
            ),
          ],
          child: const AppView(),
        ));
  }
}
