import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cbl_learning_path/features/developer/developer_info.dart';

class DeveloperInfoWidget extends StatelessWidget {
  const DeveloperInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DevInfoBloc, DevInfoState>(builder: (context, state) {
      switch (state.status) {
        case DevInfoStatus.fail:
          return const Center(
              child: Text("Failed to get information about the database"));
        case DevInfoStatus.loading:
          return const Center(child: CircularProgressIndicator());
        case DevInfoStatus.uninitialized:
          return const Center(child: CircularProgressIndicator());
        case DevInfoStatus.success:
          return SafeArea(
              child: ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Card(
                            child: ListTile(
                          title: Text(state.items[index].title),
                          subtitle: Text(state.items[index].details),
                          isThreeLine: true,
                        )));
                  }));
      }
    });
  }
}
