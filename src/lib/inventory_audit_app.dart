import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cbl_learning_path/features/router/route.dart';
import 'package:flutter_cbl_learning_path/features/database/database.dart';
import './app_view.dart';

class InventoryAuditApp extends StatelessWidget {
  final FakeAuthenticationService authService;
  final AppRouterService routerService;
  final DatabaseProvider databaseProvider;

  const InventoryAuditApp(
      {Key? key,
      required this.authService,
      required this.routerService,
      required this.databaseProvider})
      : super(key: key);

  // This is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: authService),
          RepositoryProvider.value(value: routerService),
          RepositoryProvider.value(value: databaseProvider),
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
