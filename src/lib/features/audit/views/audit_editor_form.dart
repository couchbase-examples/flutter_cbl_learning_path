import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_cbl_learning_path/features/audit/bloc/audit_editor.dart';
import 'package:flutter_cbl_learning_path/features/audit/data/stock_item_repository.dart';

import '../../../models/models.dart';
import '../bloc/stockItem_search.dart';
import '../services/stock_item_selection_service.dart';

class AuditEditorForm extends StatelessWidget {
  const AuditEditorForm({super.key });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Center(
            child: SingleChildScrollView(
                child: Column(children: const <Widget>[
                  _StockItemSelector(),
                  _CountInput(),
                  _NotesInput(),
                  _SaveButton(),
                ]
              )
          )
        )
    );
  }
}

class _NotesInput extends StatelessWidget {
  const _NotesInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuditEditorBloc, AuditEditorState>(
      buildWhen: (previous, current) =>
      previous.notes != current.notes,
      builder: (context, state) {
        TextEditingController? controller;
        if (state.status == FormEditorStatus.dataLoaded) {
          controller = TextEditingController(text: state.notes);
        }
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: TextField(
              controller: controller,
              key: const Key('auditEditor_NotesInput_textField'),
              keyboardType: TextInputType.text,
              onChanged: (notes) => context
                  .read<AuditEditorBloc>()
                  .add(AuditEditorNotesChangedEvent(notes)),
              decoration: const InputDecoration(
                labelText: 'Notes',
              ),
            ));
      },
    );
  }
}

class _CountInput extends StatelessWidget {
  const _CountInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuditEditorBloc, AuditEditorState>(
      buildWhen: (previous, current) => previous.auditCount != current.auditCount,
      builder: (context, state) {
        TextEditingController? controller;
        if (state.status == FormEditorStatus.dataLoaded) {
          controller = TextEditingController(text: state.auditCount.toString());
        }
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: TextField(
              controller: controller,
              key: const Key('projectEditor_nameInput_textField'),
              keyboardType: TextInputType.number,
              onChanged: (auditCount) => context
                  .read<AuditEditorBloc>()
                  .add(AuditEditorCountChangedEvent(int.parse(auditCount))),
              decoration: const InputDecoration(
                labelText: 'Count',
              ),
            ));
      },
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuditEditorBloc, AuditEditorState>(
        builder: (context, state) {
      if (state.status == FormEditorStatus.dataSaved ||
          state.status == FormEditorStatus.cancelled) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
              onPressed: () => context
                  .read<AuditEditorBloc>()
                  .add(const AuditEditorSaveEvent()),
              child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white, fontSize: 24.0),
                  ))),
        );
      }
    });
  }
}

class _StockItemSearchScreen extends StatelessWidget {
  const _StockItemSearchScreen();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) {
          return StockItemSearchBloc(
              repository: RepositoryProvider.of<StockItemRepository>(context),
              stockItemSelectionService: RepositoryProvider.of<StockItemSelectionService>(context));
        },
        child: SafeArea(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.all(16),
                color: Colors.grey,
                child: Scaffold(
                    body: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(Icons.close),
                              color: Colors.black,
                            ),
                          ),
                          const _NameInput(),
                          const _DescriptionInput(),
                          const _StockItemSearchButton(),
                          const _ErrorText(),
                          const Expanded(child: _StockItemList())
                        ])))));
  }
}

class _NameInput extends StatelessWidget {
  const _NameInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StockItemSearchBloc, StockItemSearchState>(
      buildWhen: (previous, current) =>
      previous.searchName != current.searchName,
      builder: (context, state) {
        TextEditingController? controller;
        if (state.status == FormEditorStatus.dataLoaded) {
          controller = TextEditingController(text: state.searchName);
        }
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: TextField(
              controller: controller,
              key: const Key('auditStockItemSearch_nameInput_textField'),
              keyboardType: TextInputType.text,
              onChanged: (searchName) => context
                  .read<StockItemSearchBloc>()
                  .add(StockItemSearchNameChangedEvent(searchName)),
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ));
      },
    );
  }
}

class _DescriptionInput extends StatelessWidget {
  const _DescriptionInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StockItemSearchBloc, StockItemSearchState>(
      buildWhen: (previous, current) =>
      previous.searchDescription != current.searchDescription,
      builder: (context, state) {
        TextEditingController? controller;
        if (state.status == FormEditorStatus.dataLoaded) {
          controller = TextEditingController(text: state.searchDescription);
        }
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: TextField(
              controller: controller,
              key: const Key('auditStockItemSearch_descriptionInput_textField'),
              keyboardType: TextInputType.text,
              onChanged: (searchDescription) => context
                  .read<StockItemSearchBloc>()
                  .add(StockItemSearchNameChangedEvent(searchDescription)),
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
            ));
      },
    );
  }
}

class _StockItemSearchButton extends StatelessWidget {
  const _StockItemSearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<StockItemSearchBloc, StockItemSearchState>(
      listener: (context, state) {
        if (state.status == FormEditorStatus.dataSaved ||
            state.status == FormEditorStatus.cancelled) {
          Navigator.of(context).pop();
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0),
        child: ElevatedButton(
          onPressed: () => context
              .read<StockItemSearchBloc>()
              .add(const StockItemSearchSubmitChangedEvent()),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Search",
              style: TextStyle(color: Colors.white, fontSize: 24.0),
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorText extends StatelessWidget {
  const _ErrorText({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StockItemSearchBloc, StockItemSearchState>(
      buildWhen: (previous, current) => previous.error != current.error,
      builder: (context, state) {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Text(state.error,
                style: const TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)));
      },
    );
  }
}

class _StockItemList extends StatelessWidget {
  const _StockItemList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StockItemSearchBloc, StockItemSearchState>(
        buildWhen: (previous, current) =>
        previous.items != current.items,
        builder: (context, state) {
          return Padding(
              padding:
              const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
              child: ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: ()  {
                          context
                              .read<StockItemSearchBloc>()
                              .add(StockItemSearchSelectionEvent(state.items[index]));
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                            child: Card(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                          title: Text(state.items[index].name),
                                          subtitle: Text(
                                              '${state.items[index].name}, ${state.items[index].description}')),
                                    ]))));
                  }));
        });
  }
}

class _StockItemSelected extends StatelessWidget {
  const _StockItemSelected({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuditEditorBloc, AuditEditorState>(
        buildWhen: (previous, current) =>
        previous.stockItem != current.stockItem,
        builder: (context, state) {
          return Container(
            alignment: Alignment.centerLeft,
            height: 50,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(state.stockItem?.name ?? 'Select Stock Item',
                      style: const TextStyle(
                          color: Colors.black26,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0)),
                  Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const <Widget>[
                          Icon(Icons.widgets,
                              size: 24.0, color: Colors.black26),
                        ]),
                  )
                ]),
          );
        });
  }
}

class _StockItemSelector extends StatelessWidget {
  const _StockItemSelector();

  @override
  Widget build(BuildContext context){
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              elevation: 4.0,
              backgroundColor: Colors.white,
            ),
            onPressed: () =>
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
                      return const _StockItemSearchScreen();
                    })
            ,
            child: const _StockItemSelected()));
  }
}

