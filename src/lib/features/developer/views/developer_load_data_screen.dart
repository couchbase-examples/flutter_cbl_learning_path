import 'package:flutter/material.dart';

class DeveloperSampleDataScreen extends StatelessWidget {
  const DeveloperSampleDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Load Sample Data'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to first screen when tapped.
          },
          child: const Text('Developer Load Sample Data Screen!'),
        ),
      ),
    );
  }
}
