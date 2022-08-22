import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cbl_learning_path/features/router/route.dart';
import '../login.dart';
import 'login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const LoginScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(2),
            child: BlocProvider(
              create: (context) {
                return LoginBloc(
                  authenticationService:
                      RepositoryProvider.of<FakeAuthenticationService>(context),
                );
              },
              child: const LoginForm(),
            )));
  }
}
