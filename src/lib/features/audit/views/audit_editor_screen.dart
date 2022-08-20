import 'package:flutter/material.dart';

class AuditEditorScreen extends StatelessWidget {
  const AuditEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audit Editor'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to first screen when tapped.
          },
          child: const Text('Audit Editor Here!'),
        ),
      ),
    );
  }
}
