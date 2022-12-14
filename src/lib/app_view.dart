import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_cbl_learning_path/features/router/route.dart';
import 'package:flutter_cbl_learning_path/features/project/project.dart';
import 'package:flutter_cbl_learning_path/features/audit/audit.dart';
import 'package:flutter_cbl_learning_path/features/login/login.dart';
import 'package:flutter_cbl_learning_path/features/splash/splash.dart';
import 'package:flutter_cbl_learning_path/features/developer/developer.dart';
import 'package:flutter_cbl_learning_path/features/replicator/replicator.dart';
import 'package:flutter_cbl_learning_path/theme/palette.dart';

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
        "/projects": (context) => ProjectListScreen(
            routerService: RepositoryProvider.of<AppRouterService>(context)),
        "/projectEditor": (context) => ProjectEditorScreen(
            routerService: RepositoryProvider.of<AppRouterService>(context)),
        "/audits": (context) => AuditListScreen(
            routerService: RepositoryProvider.of<AppRouterService>(context)),
        "/auditEditor": (context) => AuditEditorScreen(
            routerService: RepositoryProvider.of<AppRouterService>(context)),
        "/dev": (context) => DeveloperMenuScreen(
            routerService: RepositoryProvider.of<AppRouterService>(context)),
        "/devInfo": (context) => DeveloperInfoScreen(
            routerService: RepositoryProvider.of<AppRouterService>(context)),
        "/devLoadSampleData": (context) => const DeveloperSampleDataScreen(),
        "/replicator": (context) => ReplicatorScreen(routerService: RepositoryProvider.of<AppRouterService>(context)),
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
              if (state.status == AuthenticationStatus.authenticated) {
                switch (state.route.routeToScreen) {
                  case RouteToScreen.projects:
                    {
                      _navigator.pushNamedAndRemoveUntil(
                          "/projects", (route) => false);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    }
                    break;
                  case RouteToScreen.projectEditor:
                    {
                      _navigator.pushNamed("/projectEditor",
                          arguments: {state.route});
                    }
                    break;
                  case RouteToScreen.audits:
                    {
                      _navigator.pushNamed("/audits", arguments: {state.route});
                    }
                    break;
                  case RouteToScreen.auditEditor:
                    {
                      _navigator
                          .pushNamed("/auditEditor", arguments: {state.route});
                    }
                    break;
                  case RouteToScreen.userProfileEditor:
                    {
                      _navigator.pushNamed("/userProfileEditor");
                    }
                    break;
                  case RouteToScreen.developer:
                    {
                      _navigator.pushNamedAndRemoveUntil(
                          "/dev", (route) => false);
                    }
                    break;
                  case RouteToScreen.developerInfo:
                    {
                      _navigator.pushNamed("/devInfo");
                    }
                    break;
                  case RouteToScreen.replicator:
                    {
                      _navigator.pushNamedAndRemoveUntil(
                          "/replicator", (route) => false);
                    }
                    break;
                  case RouteToScreen.replicatorConfig:
                    {
                      _navigator.pushNamed("/replicatorConfig");
                    }
                    break;
                  case RouteToScreen.pop:
                    {
                      _navigator.pop();
                    }
                    break;

                  //not needed to handled
                  default:
                    break;
                }
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
