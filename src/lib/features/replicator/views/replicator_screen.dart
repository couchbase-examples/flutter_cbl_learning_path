import 'package:flutter/material.dart';
import 'package:flutter_cbl_learning_path/features/drawer/drawer.dart';

class ReplicatorScreen extends StatelessWidget {
  const ReplicatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Replicator Information'),
      ),
      drawer: const MenuDrawer(),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to first screen when tapped.
          },
          child: const Text('Replicator Screen!'),
        ),
      ),
    );
  }
}
