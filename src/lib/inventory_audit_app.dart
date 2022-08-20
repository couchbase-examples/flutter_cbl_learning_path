import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cbl_learning_path/features/authentication/authentication.dart';
import './app_view.dart';

class InventoryAuditApp extends StatelessWidget {
  final FakeAuthenticationService authService;

  const InventoryAuditApp({Key? key, required this.authService})
      : super(key: key);

  // This is the root of the application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authService,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(authService),
        child: const AppView(),
      ),
    );
  }
}
