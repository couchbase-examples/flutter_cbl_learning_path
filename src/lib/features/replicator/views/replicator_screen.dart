import 'package:flutter/material.dart';
import 'package:flutter_cbl_learning_path/features/drawer/drawer.dart';
import 'package:flutter_cbl_learning_path/features/replicator/views/replicator_status_widget.dart';
import 'package:flutter_cbl_learning_path/features/router/route.dart';

class ReplicatorScreen extends StatelessWidget {
  const ReplicatorScreen({super.key, required this.routerService});

  final AppRouterService routerService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: const Text('Replicator Status'),
            //do something
        ),
        drawer: const MenuDrawer(),
        body: const SafeArea(
            child: Padding(
                padding: EdgeInsets.all(16), child: ReplicatorStatusWidget())));
  }
}
