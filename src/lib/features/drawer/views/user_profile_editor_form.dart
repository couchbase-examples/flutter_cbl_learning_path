import 'package:flutter_cbl_learning_path/features/drawer/bloc/user_profile_bloc.dart';
import 'package:flutter_cbl_learning_path/features/drawer/bloc/user_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfileEditorForm extends StatelessWidget {
  const UserProfileEditorForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserProfileBloc, UserProfileState>(
        listener: (context, state) {},
        child: SafeArea(
          child: Center(
              child: SingleChildScrollView(
            child: Column(
              children: const <Widget>[Text('Hello World')],
            ),
          )),
        ));
  }
}
