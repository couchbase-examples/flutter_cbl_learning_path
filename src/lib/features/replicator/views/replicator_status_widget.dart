import 'package:flutter/material.dart';

class ReplicatorStatusWidget extends StatelessWidget {
  const ReplicatorStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: const <Widget>[
          _ReplicatorStatusText()
        ]
    );
  }
}

class _ReplicatorStatusText extends StatelessWidget {
  const _ReplicatorStatusText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('Replicator Status:',
      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),);
  }
}