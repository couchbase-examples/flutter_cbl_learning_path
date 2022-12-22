import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cbl_learning_path/features/drawer/bloc/user_profile_editor_bloc.dart';
import 'package:flutter_cbl_learning_path/features/drawer/bloc/user_profile_editor_event.dart';
import 'package:flutter_cbl_learning_path/features/drawer/bloc/user_profile_editor_state.dart';
import 'package:flutter_cbl_learning_path/features/drawer/data/user_repository.dart';
import 'package:flutter_cbl_learning_path/models/form_status.dart';

class UserProfileEditorWidget extends StatelessWidget {
  const UserProfileEditorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) {
          return UserProfileEditorBloc(
            userRepository: RepositoryProvider.of<UserRepository>(context),
          )..add(const UserProfileEditorLoadEvent());
        },
        child: SafeArea(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.all(20),
                color: Colors.grey,
                child: Scaffold(
                    body: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.close),
                          color: Colors.black,
                        ),
                      ),
                      _FirstNameInput(),
                      _LastNameInput(),
                      _JobTitleInput(),
                      _SaveButton(),
                    ])))));
  }
}

class _FirstNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileEditorBloc, UserProfileEditorState>(
      buildWhen: (previous, current) => previous.firstName != current.firstName,
      builder: (context, state) {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: TextField(
              controller: TextEditingController()
                ..text = state.firstName
                ..selection =
                    TextSelection.collapsed(offset: state.firstName.length),
              key: const Key('userProfileEditor_firstNameInput_textField'),
              keyboardType: TextInputType.text,
              onChanged: (firstName) => context
                  .read<UserProfileEditorBloc>()
                  .add(FirstNameChangedEvent(firstName)),
              decoration: const InputDecoration(
                labelText: 'First Name',
              ),
            ));
      },
    );
  }
}

class _LastNameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileEditorBloc, UserProfileEditorState>(
      buildWhen: (previous, current) => previous.lastName != current.lastName,
      builder: (context, state) {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: TextField(
              controller: TextEditingController()
                ..text = state.lastName
                ..selection =
                    TextSelection.collapsed(offset: state.lastName.length),
              key: const Key('userProfileEditor_lastNameInput_textField'),
              keyboardType: TextInputType.text,
              onChanged: (lastName) => context
                  .read<UserProfileEditorBloc>()
                  .add(LastNameChangedEvent(lastName)),
              decoration: const InputDecoration(
                labelText: 'Last Name',
              ),
            ));
      },
    );
  }
}

class _JobTitleInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileEditorBloc, UserProfileEditorState>(
      buildWhen: (previous, current) => previous.jobTitle != current.jobTitle,
      builder: (context, state) {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: TextField(
              controller: TextEditingController()
                ..text = state.jobTitle
                ..selection =
                    TextSelection.collapsed(offset: state.jobTitle.length),
              key: const Key('userProfileEditor_jobTitleInput_textField'),
              keyboardType: TextInputType.text,
              onChanged: (jobTitle) => context
                  .read<UserProfileEditorBloc>()
                  .add(JobTitleChangedEvent(jobTitle)),
              decoration: const InputDecoration(
                labelText: 'Job Title',
              ),
            ));
      },
    );
  }
}

class _SaveButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<UserProfileEditorBloc, UserProfileEditorState>(
      listener: (context, state) {
        if (state.status == FormEditorStatus.dataSaved ||
            state.status == FormEditorStatus.cancelled) {
          Navigator.of(context).pop();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => context
              .read<UserProfileEditorBloc>()
              .add(const UserProfileEditorSaveEvent()),
          child: const Text(
            "Save",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
