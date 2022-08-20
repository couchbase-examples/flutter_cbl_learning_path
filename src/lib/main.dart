import 'package:flutter/material.dart';
import './inventory_audit_app.dart';
import './features/authentication/authentication.dart';

void main() {
  runApp(InventoryAuditApp(authService: FakeAuthenticationService()));
}
