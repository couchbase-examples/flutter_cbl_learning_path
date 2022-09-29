import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cbl_learning_path/features/drawer/data/user_repository.dart';
import 'package:flutter_cbl_learning_path/features/drawer/user_profile.dart';
import 'package:flutter_cbl_learning_path/features/drawer/views/user_profile_widget.dart';


class UserProfile extends StatelessWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<UserProfileBloc>(
          create: (context) => UserProfileBloc(
                userRepository: RepositoryProvider.of<UserRepository>(context),
              )..add(UserProfileGetDataEvent())),
      ],
      child: const UserProfileWidget());
  }
}
