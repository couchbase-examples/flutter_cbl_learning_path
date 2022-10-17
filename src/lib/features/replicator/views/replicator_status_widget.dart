import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cbl_learning_path/features/replicator/bloc/replicator_bloc.dart';

class ReplicatorStatusWidget extends StatelessWidget {
  const ReplicatorStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: const <Widget>[
          _ReplicatorStatusText(),
          _ReplicatorButtons(),
          Padding(
              padding: EdgeInsets.only(top: 4, bottom: 2),
              child: Divider(height: 1, thickness: 2, indent: 1, endIndent: 1, color: Colors.black38)
          ),
        ]
    );
  }
}

class _ReplicatorButtons extends StatelessWidget {
  const _ReplicatorButtons({super.key});

  @override
  Widget build(BuildContext context){
    return BlocBuilder<ReplicatorBloc, ReplicatorState>(
        builder: (context, state) {
          return Row(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 6.0, right: 6.0),
                    child: ElevatedButton(
                        onPressed: () => context
                            .read<ReplicatorBloc>()
                            .add(const ReplicatorStartEvent()),
                        child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child:
                            Text("Start",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24.0))
                        )
                    )
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 6.0, right: 6.0),
                    child: ElevatedButton(
                        onPressed: () => context
                            .read<ReplicatorBloc>()
                            .add(const ReplicatorStopEvent()),
                        child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child:
                            Text("Stop",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24.0))
                        )
                    )
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 6.0, right: 6.0),
                    child: ElevatedButton(
                        onPressed: () => context
                            .read<ReplicatorBloc>()
                            .add(const ReplicatorClearLogsEvent()),
                        child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child:
                            Text("Clear",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24.0))
                        )
                    )
                )
              ]
          );
        });
  }
}

class _ReplicatorStatusText extends StatelessWidget {
  const _ReplicatorStatusText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const <Widget>[
        Text('Replicator Status:',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)
        )
      ],
    );
  }
}