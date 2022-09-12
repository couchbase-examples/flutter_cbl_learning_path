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
                      primary: Colors.white,
                      padding: const EdgeInsets.all(4.0),
                      textStyle: const TextStyle(fontSize: 12)),
                  onPressed: () {},
                  child: const Text('Update Profile',
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
