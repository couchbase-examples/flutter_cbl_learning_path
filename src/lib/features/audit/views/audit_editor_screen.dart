import 'package:flutter/material.dart';

import '../../../widgets/back_navigation.dart';

class AuditEditorScreen extends BackNavigationStatelessWidget {
  const AuditEditorScreen({super.key, required super.routerService});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onBackPressed,
        child:Scaffold(
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
    ));
  }
}
