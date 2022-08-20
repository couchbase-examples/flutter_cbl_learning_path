import 'package:flutter/material.dart';
import 'package:flutter_cbl_learning_path/features/drawer/drawer.dart';

class DeveloperMenuScreen extends StatelessWidget {
  const DeveloperMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Options'),
      ),
      drawer: const MenuDrawer(),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to first screen when tapped.
          },
          child: const Text('List Developer Options Here!'),
        ),
      ),
    );
  }
}
