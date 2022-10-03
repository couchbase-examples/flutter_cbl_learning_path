import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_cbl_learning_path/models/form_status.dart';

import '../bloc/project_editor_bloc.dart';
import '../bloc/project_editor_event.dart';
import '../bloc/project_editor_state.dart';

class ProjectEditorForm extends StatelessWidget {
  const ProjectEditorForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Center(
            child: SingleChildScrollView(
                child: Column(children: const <Widget>[
      _NameInput(),
      _DescriptionInput(),
      _DueDateDateSelector(),
      _SaveButton(),
    ]))));
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
        if (state.status == FormEditorStatus.dataLoaded) {
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
      buildWhen: (previous, current) =>
          previous.description != current.description,
      builder: (context, state) {
        TextEditingController? controller;
        if (state.status == FormEditorStatus.dataLoaded) {
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

class _DueDateDateSelector extends StatelessWidget {
  const _DueDateDateSelector();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              elevation: 4.0,
              backgroundColor: Colors.white,
            ),
            onPressed: () {
              final Future<DateTime?> pickedDate = showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2030));
              context
                  .read<ProjectEditorBloc>()
                  .add(ProjectEditorDueDateChangeEvent(pickedDate));
            },
            child: const _DueDateSelectedText()));
  }
}

class _DueDateSelectedText extends StatelessWidget {
  const _DueDateSelectedText({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectEditorBloc, ProjectEditorState>(
        buildWhen: (previous, current) => previous.dueDate != current.dueDate,
        builder: (context, state) {
          return Container(
              alignment: Alignment.center,
              height: 50.0,
              child: Row(children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: <Widget>[
                      const Icon(Icons.date_range,
                          size: 18.0, color: Colors.black26),
                      Text(" ${state.dueDate}",
                          style: const TextStyle(
                              color: Colors.black26,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0))
                    ]),
                  ],
                )
              ]));
        });
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectEditorBloc, ProjectEditorState>(
        builder: (context, state) {
      if (state.status == FormEditorStatus.dataSaved ||
          state.status == FormEditorStatus.cancelled) {
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
