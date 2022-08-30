import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_cbl_learning_path/features/router/route.dart';
import 'package:flutter_cbl_learning_path/features/project/project.dart';
import 'package:flutter_cbl_learning_path/features/audit/audit.dart';
import 'package:flutter_cbl_learning_path/features/login/login.dart';
import 'package:flutter_cbl_learning_path/features/splash/splash.dart';
import 'package:flutter_cbl_learning_path/features/developer/developer.dart';
import 'package:flutter_cbl_learning_path/features/replicator/replicator.dart';

import './theme/palette.dart';

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
        "/dev": (context) => DeveloperMenuScreen(
            routerService: RepositoryProvider.of<AppRouterService>(context)),
        "/devInfo": (context) => DeveloperInfoScreen(
            routerService: RepositoryProvider.of<AppRouterService>(context)),
        "/devLoadSampleData": (context) => const DeveloperSampleDataScreen(),
        "/replicator": (context) => const ReplicatorScreen(),
        "/replicatorConfig": (context) => const ReplicatorConfigScreen(),
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
        return MultiBlocListener(
          listeners: [
            BlocListener<RouteBloc, RouteState>(listener: (context, state) {
              if (state.status == AuthenticationStatus.authenticated &&
                  state.route == RouteToScreen.projects) {
                _navigator.pushAndRemoveUntil(
                    ProjectListScreen.route(), (route) => false);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              } else if (state.status == AuthenticationStatus.authenticated &&
                  state.route == RouteToScreen.audits) {
                _navigator.pushNamed("/audits");
              } else if (state.status == AuthenticationStatus.authenticated &&
                  state.route == RouteToScreen.auditEditor) {
                _navigator.pushNamed("/auditEditor");
              } else if (state.status == AuthenticationStatus.authenticated &&
                  state.route == RouteToScreen.projectEditor) {
                _navigator.pushNamed("/projectEditor");
              } else if (state.status == AuthenticationStatus.authenticated &&
                  state.route == RouteToScreen.developer) {
                _navigator.pushNamedAndRemoveUntil("/dev", (route) => false);
              } else if (state.status == AuthenticationStatus.authenticated &&
                  state.route == RouteToScreen.developerInfo) {
                _navigator.pushNamed("/devInfo");
              } else if (state.status == AuthenticationStatus.authenticated &&
                  state.route == RouteToScreen.replicator) {
                _navigator.pushNamedAndRemoveUntil(
                    "/replicator", (route) => false);
              } else if (state.status == AuthenticationStatus.authenticated &&
                  state.route == RouteToScreen.replicatorConfig) {
                _navigator.pushNamed("/replicatorConfig");
              } else if (state.status == AuthenticationStatus.authenticated &&
                  state.route == RouteToScreen.pop) {
                _navigator.pop();
              } else {
                if (state.status != AuthenticationStatus.authenticatedFailed) {
                  _navigator.pushAndRemoveUntil(
                      LoginScreen.route(), (route) => false);
                }
              }
            }),
          ],
          child: child!,
        );
      },
      onGenerateRoute: (_) => SplashScreen.route(),
    );
  }
}
