import 'package:flutter/material.dart';
import 'package:flutter_cbl_learning_path/features/drawer/drawer.dart';

class ProjectListScreen extends StatelessWidget {
  const ProjectListScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const ProjectListScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
      ),
      drawer: const MenuDrawer(),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to first screen when tapped.
          },
          child: const Text('List Projects Here!'),
        ),
      ),
    );
  }
}
