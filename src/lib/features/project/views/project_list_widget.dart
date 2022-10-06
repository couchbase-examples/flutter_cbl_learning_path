import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cbl_learning_path/features/audit/bloc/audit_list_bloc.dart';
import '../../../models/models.dart';
import '../../router/service/router_service.dart';
import '../bloc/project_list.dart';

class ProjectListWidget extends StatelessWidget {
  const ProjectListWidget({super.key, required this.routerService});

  final AppRouterService routerService;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectListBloc, ProjectListState>(
        builder: (context, state) {
      switch (state.status) {
        case DataStatus.uninitialized:
          return const Center(child: CircularProgressIndicator());
        case DataStatus.loading:
          return const Center(child: CircularProgressIndicator());
        case DataStatus.loaded:
        case DataStatus.changed:
          return SafeArea(
              child: ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () => {
                              routerService.routeTo(ScreenRoute(
                                  routeToScreen: RouteToScreen.audits,
                                  projectId: state.items[index].projectId,
                                  auditListBloc:
                                      BlocProvider.of<AuditListBloc>(context)))
                            },
                        child: ProjectCard(
                            project: state.items[index],
                            routerService: routerService));
                  }));
        case DataStatus.empty:
          return const Center(child: Text("No Data was Found"));
        case DataStatus.error:
          return Center(child: Text("Failed with error: ${state.error}"));
        case DataStatus.cancelled:
          return const Center(child: Text("Loading was cancelled."));
      }
    });
  }
}

class ProjectCard extends StatelessWidget {
  const ProjectCard(
      {super.key, required this.project, required this.routerService});

  final Project project;
  final AppRouterService routerService;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 12.0, bottom: 16.0),
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TitleRow(project: project, routerService: routerService),
              IconRow(
                  title: project.warehouse?.name,
                  icon: const Icon(Icons.location_on, size: 16)),
              Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: IconRow(
                      title: project.dueDateToString(),
                      icon: const Icon(Icons.calendar_today, size: 16))),
              Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: IconRow(
                      title: project.team,
                      icon: const Icon(Icons.group, size: 16))),
              Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 30, left: 16),
                  child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(project.description)))
            ],
          ),
        ));
  }
}

class TitleRow extends StatelessWidget {
  const TitleRow(
      {super.key, required this.project, required this.routerService});

  final Project project;
  final AppRouterService routerService;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Expanded(
          child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(project.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 17)))),
      PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                const PopupMenuItem(
                    child: ListTile(
                        leading: Icon(Icons.edit), title: Text('Edit'))),
                const PopupMenuItem(
                    child: ListTile(
                        leading: Icon(Icons.delete), title: Text('Delete'))),
              ]),
    ]);
  }
}

class IconRow extends StatelessWidget {
  const IconRow({super.key, required this.title, required this.icon});

  final String? title;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    String text = title ?? ' ';
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.only(left: 16), child: icon),
      Expanded(
          child: Padding(
              padding: const EdgeInsets.only(left: 1),
              child: Text(text,
                  style: const TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 14)))),
    ]);
  }
}