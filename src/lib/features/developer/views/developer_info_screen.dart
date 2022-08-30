import 'package:flutter/material.dart';
import 'package:flutter_cbl_learning_path/widgets/back_navigation.dart';

class DeveloperInfoScreen extends BackNavigationStatelessWidget {
  const DeveloperInfoScreen({super.key, required super.routerService});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Developer Information'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              // Navigate back to first screen when tapped.
            },
            child: const Text('Developer Info Screen!'),
          ),
        ),
      ),
    );
  }
}
