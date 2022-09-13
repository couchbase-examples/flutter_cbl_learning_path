import 'package:flutter/material.dart';

class UserProfileEditorScreen extends StatelessWidget {
  const UserProfileEditorScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
        builder: (_) => const UserProfileEditorScreen());
  }

  @override
  Widget build(BuildContext context) {
    return const Text('Hello World');
  }
}
