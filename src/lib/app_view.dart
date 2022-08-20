import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './theme/palette.dart';

import 'package:flutter_cbl_learning_path/features/authentication/authentication.dart';
import 'package:flutter_cbl_learning_path/features/project/project.dart';
import 'package:flutter_cbl_learning_path/features/audit/audit.dart';
import 'package:flutter_cbl_learning_path/features/login/login.dart';
import 'package:flutter_cbl_learning_path/features/splash/splash.dart';
import 'package:flutter_cbl_learning_path/features/developer/developer.dart';
import 'package:flutter_cbl_learning_path/features/replicator/replicator.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'Inventory Audit',
      routes: {
        "/login": (context) => const LoginScreen(),
        "/projects": (context) => const ProjectListScreen(),
        "/projectEditor": (context) => const ProjectEditorScreen(),
        "/audits": (context) => const AuditListScreen(),
        "/auditEditor": (context) => const AuditEditorScreen(),
        "/dev": (context) => const DeveloperMenuScreen(),
        "/devInfo": (context) => const DeveloperInfoScreen(),
        "/devLoadSampleData": (context) => const DeveloperSampleDataScreen(),
        "/devReplicator": (context) => const ReplicatorScreen(),
        "/devReplicatorConfig": (context) => const ReplicatorConfigScreen(),
      },
      theme: ThemeData(
        primarySwatch: Palette.couchbaseRed,
        backgroundColor: Palette.couchbaseRed,
        buttonTheme: const ButtonThemeData(
          buttonColor: Palette.couchbaseRed,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state.status == AuthenticationStatus.authenticated) {
              _navigator.pushAndRemoveUntil(
                  ProjectListScreen.route(), (route) => false);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            } else {
              if (state.status != AuthenticationStatus.authenticatedFailed) {
                _navigator.pushAndRemoveUntil(
                    LoginScreen.route(), (route) => false);
              }
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashScreen.route(),
    );
  }
}
