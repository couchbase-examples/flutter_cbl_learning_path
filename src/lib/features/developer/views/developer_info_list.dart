import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../developer_info.dart';

class DeveloperInfoWidget extends StatelessWidget {
  const DeveloperInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DevInfoBloc, DevInfoState>(
        listener: (context, state) {
          if (state.status == DevInfoStatus.fail) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(state.error)),
              );
          }
        },
        child: const Text('hello world'));
  }
}
