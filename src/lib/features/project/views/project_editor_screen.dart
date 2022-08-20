import 'package:flutter/material.dart';

class ProjectEditorScreen extends StatelessWidget {
  const ProjectEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
