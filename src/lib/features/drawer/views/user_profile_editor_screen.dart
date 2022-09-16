import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cbl_learning_path/features/drawer/data/user_repository.dart';
import 'package:flutter_cbl_learning_path/features/drawer/user_profile.dart';
import 'package:flutter_cbl_learning_path/features/drawer/views/user_profile_editor_form.dart';

class UserProfileEditorScreen extends StatelessWidget {
  const UserProfileEditorScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
        builder: (_) => const UserProfileEditorScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('User Profile Editor'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(2),
            child: BlocProvider(
              create: (context) {
                return UserProfileBloc(
                  userRepository:
                      RepositoryProvider.of<UserRepository>(context),
                );
              },
              child: const UserProfileEditorForm(),
            )));
  }
}
