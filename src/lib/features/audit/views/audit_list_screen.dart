import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cbl_learning_path/features/audit/bloc/audit_list_event.dart';
import 'package:flutter_cbl_learning_path/features/audit/views/audit_list_widget.dart';
import 'package:flutter_cbl_learning_path/features/router/route.dart';
import '../bloc/audit_list_bloc.dart';
import '../data/audit_repository.dart';

class AuditListScreen extends StatelessWidget {
  const AuditListScreen({super.key, required this.routerService});

  final AppRouterService routerService;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Set<ScreenRoute>;
    var routeScreen = args.first;
    var projectId = routeScreen.projectId as String;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Audits'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(2),
            child: BlocProvider(
                create: (context) {
                  return AuditListBloc(
                      repository: RepositoryProvider.of<AuditRepository>(context))
                    ..add(AuditListInitializeEvent(projectId: projectId));
                },
                child: AuditListWidget(routerService: routerService)
            )
        )
    );
  }
}