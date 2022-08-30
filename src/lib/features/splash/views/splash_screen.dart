import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cbl_learning_path/features/router/route.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const SplashScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RouteBloc, RouteState>(builder: (context, state) {
      return Scaffold(
        body: Center(child: AppStartProgressIndicator(context: context)),
      );
    });
  }
}

class AppStartProgressIndicator extends CircularProgressIndicator {
  final BuildContext context;

  AppStartProgressIndicator({super.key, required this.context}) {
    context.read<RouteBloc>().add(AppLoaded());
  }
}
