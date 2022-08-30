import 'package:flutter/material.dart';
import './inventory_audit_app.dart';
import 'features/router/route.dart';
import 'features/database/database_provider.dart';

void main() {
  runApp(InventoryAuditApp(
      authService: FakeAuthenticationService(),
      routerService: AppRouterService(),
      databaseProvider: DatabaseProvider()));
}
