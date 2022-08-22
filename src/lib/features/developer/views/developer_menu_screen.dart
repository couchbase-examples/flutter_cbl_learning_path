import 'package:flutter/material.dart';

import 'package:flutter_cbl_learning_path/features/drawer/drawer.dart';
import 'package:flutter_cbl_learning_path/features/router/route.dart';

class DeveloperMenuScreen extends StatelessWidget {
  final AppRouterService routerService;
  const DeveloperMenuScreen({super.key, required this.routerService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Options'),
      ),
      drawer: const MenuDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        onPressed: () => {
                          routerService.routeTo(RouteToScreen.developerInfo)
                        },
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
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        onPressed: () => {},
                        child: const Text("Load Sample Data"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
