import 'package:flutter/material.dart';
import './inventory_audit_app.dart';
import 'features/router/route.dart';

void main() {
  runApp(InventoryAuditApp(
      authService: FakeAuthenticationService(),
      routerService: AppRouterService()));
}
