import 'package:flutter_cbl_learning_path/models/form_status.dart';
import 'package:formz/formz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/project_editor_bloc.dart';
import '../bloc/project_editor_event.dart';
import '../bloc/project_editor_state.dart';

class ProjectEditorForm extends StatelessWidget{
  const ProjectEditorForm({super.key});

  @override
  Widget build(BuildContext context){
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: const <Widget> [
              _NameInput(),
              _DescriptionInput(),
              _SaveButton(),
            ]
          )
        )
      )
    );
  }
}

class _NameInput extends StatelessWidget {
  const _NameInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectEditorBloc, ProjectEditorState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        TextEditingController? controller;
        if (state.status == FormEditorStatus.dataLoaded){
          controller = TextEditingController(text: state.name);
        }
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: TextField(
              controller: controller,
              key: const Key('userProfileEditor_firstNameInput_textField'),
              keyboardType: TextInputType.text,
              onChanged: (name) => context
                  .read<ProjectEditorBloc>()
                  .add(ProjectEditorNameChangedEvent(name)),
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ));
      },
    );
  }
}


class _DescriptionInput extends StatelessWidget {
  const _DescriptionInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectEditorBloc, ProjectEditorState>(
      buildWhen: (previous, current) => previous.description != current.description,
      builder: (context, state) {
        TextEditingController? controller;
        if (state.status == FormEditorStatus.dataLoaded){
          controller = TextEditingController(text: state.name);
        }
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: TextField(
              controller: controller,
              key: const Key('userProfileEditor_firstNameInput_textField'),
              keyboardType: TextInputType.text,
              onChanged: (description) => context
                  .read<ProjectEditorBloc>()
                  .add(ProjectEditorDescriptionChangedEvent(description)),
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
            ));
      },
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectEditorBloc, ProjectEditorState>(
        builder: (context, state) {
          if (state.status == FormEditorStatus.dataSaved || state.status == FormEditorStatus.cancelled) {
            Navigator.of(context).pop();
            return const Text('');
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    context
                        .read<ProjectEditorBloc>()
                        .add(const ProjectEditorSaveEvent());
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  )),
            );
          }
        });
  }
}