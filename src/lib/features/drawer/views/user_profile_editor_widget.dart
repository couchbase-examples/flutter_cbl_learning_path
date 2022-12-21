import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cbl_learning_path/features/drawer/bloc/user_profile_editor_bloc.dart';
import 'package:flutter_cbl_learning_path/features/drawer/bloc/user_profile_editor_event.dart';
import 'package:flutter_cbl_learning_path/features/drawer/bloc/user_profile_editor_state.dart';
import 'package:flutter_cbl_learning_path/features/drawer/data/user_repository.dart';
import 'package:flutter_cbl_learning_path/features/router/bloc/route_state.dart';
import 'package:flutter_cbl_learning_path/models/form_status.dart';
import 'package:image_picker/image_picker.dart';


class UserProfileEditorWidget extends StatelessWidget{
  const UserProfileEditorWidget({super.key});
  @override
  Widget build(BuildContext context){
    return BlocProvider(
        create: (context) {
          return UserProfileEditorBloc(
            userRepository:
            RepositoryProvider.of<UserRepository>(
                context),
          )..add(const UserProfileEditorLoadEvent());
        },
        child: SafeArea(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height:
                MediaQuery.of(context).size.height,
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
                          const ImageSelector(),
                          const _FirstNameInput(),
                          const _LastNameInput(),
                          const _JobTitleInput(),
                          const _SaveButton(),
                        ])))));
  }
}
class ImageSelector extends StatefulWidget {
  const ImageSelector({super.key});

  @override
  _ImageSelectorState createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector>{

  var imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context){
    final bloc = BlocProvider.of<UserProfileEditorBloc>(context);

    return BlocBuilder<UserProfileEditorBloc, UserProfileEditorState>(
      builder: (context, state) {
        if (state.imageRaw != null && (state.status == FormEditorStatus.dataLoaded || state.status == FormEditorStatus.dataChanged)) {
          var imageBytes = state.imageRaw as Uint8List;
          var image = Image.memory(imageBytes,
              alignment:
              AlignmentDirectional.center,
              height: 80,
              width: 80);
          return GestureDetector(
            onTap:() async {
              final file = await imagePicker.pickImage(source: ImageSource.gallery);
              if (file != null && mounted) {
                bloc.add(SelectImageEvent(file));
              }
            },
              child: Padding(
              padding: const EdgeInsets.all(2),
              child: ClipOval(
                  child: SizedBox.fromSize(
                      size: const Size.fromRadius(80), child: image))));
        } else  {
          return const CircleAvatar();
        }

    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class _FirstNameInput extends StatelessWidget {
  const _FirstNameInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileEditorBloc, UserProfileEditorState>(
      buildWhen: (previous, current) => previous.firstName != current.firstName,
      builder: (context, state) {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: TextField(
              controller: TextEditingController(text: state.firstName),
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
  const _LastNameInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileEditorBloc, UserProfileEditorState>(
      buildWhen: (previous, current) => previous.lastName != current.lastName,
      builder: (context, state) {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: TextField(
              controller: TextEditingController(text: state.lastName),
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
  const _JobTitleInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileEditorBloc, UserProfileEditorState>(
      buildWhen: (previous, current) => previous.jobTitle != current.jobTitle,
      builder: (context, state) {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: TextField(
              controller: TextEditingController(text: state.jobTitle),
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
  const _SaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileEditorBloc, UserProfileEditorState>(
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
                        .read<UserProfileEditorBloc>()
                        .add(const UserProfileEditorSaveEvent());
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