import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cbl_learning_path/features/project/bloc/project_editor_bloc.dart';
import 'package:flutter_cbl_learning_path/features/project/services/warehouse_selected_service.dart';
import 'package:flutter_cbl_learning_path/features/project/views/project_editor_form.dart';
import 'package:flutter_cbl_learning_path/features/router/route.dart';

import '../../../widgets/back_navigation.dart';
import '../data/project_repository.dart';

class ProjectEditorScreen extends BackNavigationStatelessWidget {
  const ProjectEditorScreen({super.key, required super.routerService});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Project Editor'),
        ),
        backgroundColor: Colors.white,
        body:  BlocProvider(
          create: (context){
            return ProjectEditorBloc(projectRepository: RepositoryProvider.of<ProjectRepository>(context),
            authenticationService: RepositoryProvider.of<AuthenticationService>(context),
            warehouseSelectionService: RepositoryProvider.of<WarehouseSelectionService>(context));
          },
          child: const ProjectEditorForm(),
        )
      ),
    );
  }
}
