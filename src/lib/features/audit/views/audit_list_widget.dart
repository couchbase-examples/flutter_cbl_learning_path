import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/models.dart';
import '../../router/service/router_service.dart';
import '../bloc/audit_list.dart';

class AuditListWidget extends StatelessWidget {
  const AuditListWidget({super.key, required this.routerService});

  final AppRouterService routerService;

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<AuditListBloc, AuditListState>(
        builder: (context, state) {
          switch (state.status) {
            case DataStatus.uninitialized:
              return const Center(child: CircularProgressIndicator());
            case DataStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case DataStatus.loaded:
              return SafeArea(
                  child: ListView.builder(
                      itemCount: state.items.length,
                      itemBuilder: (BuildContext context, int index) {
                        return  GestureDetector(
                            onTap: () => {
                            },
                            child: AuditCard(item: state.items[index], routerService: routerService)
                        );
                      }));
            case DataStatus.empty:
              return const Center(child: Text("No Data was Found"));
            case DataStatus.error:
              return Center(child: Text("Failed with error: ${state.error}"));
            case DataStatus.changed:
            // TODO: Handle this case.
              break;
            case DataStatus.cancelled:
              return const Center(child: Text("Loading was cancelled."));
          }
          return const Text('');
        });
  }
}

class AuditCard extends StatelessWidget {
  const AuditCard({super.key, required this.item, required this.routerService});

  final Audit item;
  final AppRouterService routerService;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 12.0, bottom: 16.0),
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TitleRow(item: item, routerService: routerService),
              Align(alignment: Alignment.centerLeft, child: Padding(padding: const EdgeInsets.only(top: 5, left: 16, right: 16), child: Text("Id: ${item.projectId}", textAlign: TextAlign.left))),
              Align(alignment: Alignment.centerLeft, child:Padding(padding: const EdgeInsets.only(top: 5, left: 16, right: 16), child: Text("Count: ${item.auditCount}", textAlign: TextAlign.left))),
              Align(alignment: Alignment.centerLeft, child: Padding(padding: const EdgeInsets.only(top: 5, left: 16, right: 16, bottom: 20), child: Text("Notes: ${item.notes}", textAlign: TextAlign.left))),
            ],
          ),
        ));
  }
}

class TitleRow extends StatelessWidget {
  const TitleRow({super.key, required this.item, required this.routerService});

  final Audit item;
  final AppRouterService routerService;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Expanded(child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child:Text(item.stockItem.name,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 17)))
      ),
      PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
            const PopupMenuItem(
                child: ListTile(
                    leading: Icon(Icons.edit), title: Text('Edit'))),
            const PopupMenuItem(
                child: ListTile(
                    leading: Icon(Icons.delete), title: Text('Delete'))),
          ]),
    ]);
  }
}