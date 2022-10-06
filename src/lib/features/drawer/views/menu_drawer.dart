import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cbl_learning_path/features/router/route.dart';
import 'package:flutter_cbl_learning_path/features/drawer/views/drawer_widget.dart';
import 'package:flutter_cbl_learning_path/features/login/login.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(
                authenticationService:
                    RepositoryProvider.of<FakeAuthenticationService>(context))),
      ],
      child: MenuDrawerWidget(
          routerService: RepositoryProvider.of<AppRouterService>(context)),
    );
  }
}
