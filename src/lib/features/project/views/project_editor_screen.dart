import 'package:flutter/material.dart';

import '../../../widgets/back_navigation.dart';

class ProjectEditorScreen extends BackNavigationStatelessWidget {
  const ProjectEditorScreen({super.key, required super.routerService});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onBackPressed,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Project'),
          ),
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                // Navigate back to first screen when tapped.
              },
              child: const Text('List Editor Here!'),
            ),
          ),
        ));
  }
}
