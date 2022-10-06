import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cbl_learning_path/features/router/route.dart';
import 'package:flutter_cbl_learning_path/features/developer/bloc/dev_data_load_bloc.dart';
import 'package:flutter_cbl_learning_path/features/developer/bloc/dev_data_load_event.dart';
import 'package:flutter_cbl_learning_path/features/developer/bloc/dev_data_load_state.dart';

class DeveloperMenuWidget extends StatelessWidget {
  const DeveloperMenuWidget({super.key, required this.routerService});

  final AppRouterService routerService;

  @override
  Widget build(BuildContext context) {
    return BlocListener<DevDataLoadBloc, DevDataLoadState>(
        listener: (context, state) {
          switch (state.status) {
            case DevDataLoadStatus.loading:
              {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(content: Text('Generating Data...')),
                  );
              }
              break;
            case DevDataLoadStatus.success:
              {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(content: Text('New Data Generated!')),
                  );
              }
              break;
            case DevDataLoadStatus.failed:
              {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Error generating data, please check logs for more information.')),
                  );
              }
              break;
            case DevDataLoadStatus.uninitialized:
              {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              }
              break;
          }
        },
        child: Center(
            child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: OutlinedButton(
                      key: const Key('menu_database_info'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.only(
                            top: 20, bottom: 20, left: 60, right: 60),
                        backgroundColor: Theme.of(context).backgroundColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onPressed: () =>
                          {routerService.routeTo(const ScreenRoute(routeToScreen: RouteToScreen.developerInfo))},
                      child: const Text("Database Information"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: OutlinedButton(
                      key: const Key('menu_sample_data'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.only(
                            top: 20, bottom: 20, left: 60, right: 60),
                        backgroundColor: Theme.of(context).backgroundColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onPressed: () => {
                        context
                            .read<DevDataLoadBloc>()
                            .add(DevDataLoadStartEvent())
                      },
                      child: const Text("Load Sample Data"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )));
  }
}
