import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../user_profile.dart';

class UserProfileWidget extends StatelessWidget {
  const UserProfileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (context, state) {
      switch (state.status) {
        case UserProfileStatus.fail:
          {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text('error ${state.error}')),
              );
            return const Text('');
          }
        case UserProfileStatus.uninitialized:
          {
            return const Center(child: CircularProgressIndicator());
          }
        case UserProfileStatus.success:
          {
            var imageBytes = state.userProfile['imgRaw'] as Uint8List;
            var image = Image.memory(imageBytes,
                alignment: AlignmentDirectional.center, height: 80, width: 80);
            return Center(
                child: Column(children: <Widget>[
              _ProfilePic(image: image),
              Text(state.userProfile['emailDisplay'] as String,
                  style: const TextStyle(color: Colors.white)),
              TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(4.0),
                      textStyle: const TextStyle(fontSize: 12)),
                  onPressed: () {
                    showGeneralDialog(
                        context: context,
                        barrierDismissible: false,
                        transitionDuration: const Duration(milliseconds: 200),
                        transitionBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: ScaleTransition(
                              scale: animation,
                              child: child,
                            ),
                          );
                        },
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return SafeArea(
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  padding: const EdgeInsets.all(20),
                                  color: Colors.white,
                                  child: Center(
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                        const Text("Hello World"),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                "Save",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                        ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text(
                                                    "Close",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                            ),
                                      ]))));
                        });
                  },
                  child: const Text('Update User Profile',
                      style: TextStyle(decoration: TextDecoration.underline))),
            ]));
          }
      }
    });
  }
}

class _ProfilePic extends StatelessWidget {
  const _ProfilePic({required this.image});
  final Image image;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(2),
        child: ClipOval(
            child: SizedBox.fromSize(
                size: const Size.fromRadius(34), child: image)));
  }
}
