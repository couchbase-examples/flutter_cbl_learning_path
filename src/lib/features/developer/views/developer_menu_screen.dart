import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cbl_learning_path/features/drawer/drawer.dart';
import 'package:flutter_cbl_learning_path/features/project/data/project_repository.dart';
import 'package:flutter_cbl_learning_path/features/router/route.dart';

import '../bloc/dev_data_load_bloc.dart';
import 'developer_menu_widget.dart';

class DeveloperMenuScreen extends StatelessWidget {
  const DeveloperMenuScreen({super.key, required this.routerService});

  final AppRouterService routerService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Developer Options'),
        ),
        drawer: const MenuDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocProvider(
              create: (context) {
                return DevDataLoadBloc(
                    projectRepository:
                        RepositoryProvider.of<ProjectRepository>(context));
              },
              child: DeveloperMenuWidget(routerService: routerService)),
        ));
  }
}
