import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../authentication/authentication.dart';
import '../views/drawer_widget.dart';
import '../../login/login.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return LoginBloc(
          authenticationService:
              RepositoryProvider.of<FakeAuthenticationService>(context),
        );
      },
      child: const MenuDrawerWidget(),
    );
  }
}
