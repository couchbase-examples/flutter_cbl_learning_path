import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cbl_learning_path/widgets/back_navigation.dart';

class UserProfileEditorScreen extends BackNavigationStatelessWidget {
  const UserProfileEditorScreen({super.key, required super.routerService});

  @override
  Widget build(BuildContext context){
    return WillPopScope(
        child: Text("Hello World"),
        onWillPop: onBackPressed);
  }
}