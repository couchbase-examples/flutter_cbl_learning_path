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
              if (state.status == AuthenticationStatus.authenticated) {
                switch (state.route) {
                  case RouteToScreen.projects:
                    {
                      _navigator.pushAndRemoveUntil(
                          ProjectListScreen.route(), (route) => false);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    }
                    break;
                  case RouteToScreen.projectEditor:
                    {
                      //TODO add projectId to route
                      _navigator.pushNamed("/projectEditor");
                    }
                    break;
                  case RouteToScreen.audits:
                    {
                      //TODO add projectId to route
                      _navigator.pushNamed("/audits");
                    }
                    break;
                  case RouteToScreen.auditEditor:
                    {
                      //TODO add projectId and auditId to route
                      _navigator.pushNamed("/auditEditor");
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
