import 'package:flutter/material.dart';

class ReplicatorConfigScreen extends StatelessWidget {
  const ReplicatorConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Replicator Config'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to first screen when tapped.
          },
          child: const Text('Replicator Configuration Screen!'),
        ),
      ),
    );
  }
}
