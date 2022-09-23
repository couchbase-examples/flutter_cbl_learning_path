import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/data_status.dart';
import '../bloc/project_list.dart';

class ProjectListWidget extends StatelessWidget {
  const ProjectListWidget({super.key});

  @override
  Widget build(BuildContext context){
    return BlocBuilder<ProjectListBloc, ProjectListState>(
        builder: (context, state){
      switch (state.status){
        case DataStatus.uninitialized:
            return const Center(child: CircularProgressIndicator());
        case DataStatus.loading:
            return const Center(child: CircularProgressIndicator());
        case DataStatus.loaded:
          return SafeArea(
            child: ListView.builder(
              itemCount: state.projects.length,
              itemBuilder: (BuildContext context, int index){
                return Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Card(
                    child: ListTile(title: Text(state.projects[index].name))
                  )
                );
              }
            )
          );
        case DataStatus.empty:
          return const Center(
              child: Text("No Data was Found"));
        case DataStatus.error:
          return Center(
              child: Text("Failed with error: ${state.error}"));
        case DataStatus.changed:
          // TODO: Handle this case.
          break;
        case DataStatus.cancelled:
          return const Center(
              child: Text("Loading was cancelled."));
      }
      return const Text('');
    });
  }
}