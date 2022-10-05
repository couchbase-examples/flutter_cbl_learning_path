import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_cbl_learning_path/models/form_status.dart';

import '../bloc/project_editor_bloc.dart';
import '../bloc/project_editor_event.dart';
import '../bloc/project_editor_state.dart';
import '../bloc/warehouse_search_bloc.dart';
import '../bloc/warehouse_search_event.dart';
import '../bloc/warehouse_search_state.dart';
import '../data/warehouse_repository.dart';
import '../services/warehouse_selected_service.dart';

class ProjectEditorForm extends StatelessWidget {
  const ProjectEditorForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Center(
            child: SingleChildScrollView(
                child: Column(children: const <Widget>[
      _NameInput(),
      _DescriptionInput(),
      _DueDateDateSelector(),
      _LocationSelector(),
      _SaveButton(),
    ]))));
  }
}

class _NameInput extends StatelessWidget {
  const _NameInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectEditorBloc, ProjectEditorState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        TextEditingController? controller;
        if (state.status == FormEditorStatus.dataLoaded) {
          controller = TextEditingController(text: state.name);
        }
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: TextField(
              controller: controller,
              key: const Key('projectEditor_nameInput_textField'),
              keyboardType: TextInputType.text,
              onChanged: (name) => context
                  .read<ProjectEditorBloc>()
                  .add(ProjectEditorNameChangedEvent(name)),
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
    return BlocBuilder<ProjectEditorBloc, ProjectEditorState>(
      buildWhen: (previous, current) =>
          previous.description != current.description,
      builder: (context, state) {
        TextEditingController? controller;
        if (state.status == FormEditorStatus.dataLoaded) {
          controller = TextEditingController(text: state.description);
        }
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: TextField(
              controller: controller,
              key: const Key('projectEditor_DescriptionInput_textField'),
              keyboardType: TextInputType.text,
              onChanged: (description) => context
                  .read<ProjectEditorBloc>()
                  .add(ProjectEditorDescriptionChangedEvent(description)),
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
            ));
      },
    );
  }
}

class _DueDateDateSelector extends StatelessWidget {
  const _DueDateDateSelector();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              elevation: 4.0,
              backgroundColor: Colors.white,
            ),
            onPressed: () {
              final Future<DateTime?> pickedDate = showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2030));
              context
                  .read<ProjectEditorBloc>()
                  .add(ProjectEditorDueDateChangeEvent(pickedDate));
            },
            child: const _DueDateSelectedText()));
  }
}

class _DueDateSelectedText extends StatelessWidget {
  const _DueDateSelectedText({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectEditorBloc, ProjectEditorState>(
        buildWhen: (previous, current) => previous.dueDate != current.dueDate,
        builder: (context, state) {
          return Container(
            alignment: Alignment.centerLeft,
            height: 50,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(' ${state.dueDate}',
                      style: const TextStyle(
                          color: Colors.black26,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0)),
                  Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const <Widget>[
                          Icon(Icons.date_range,
                              size: 24.0, color: Colors.black26),
                        ]),
                  )
                ]),
          );
        });
  }
}

class _LocationSelector extends StatelessWidget {
  const _LocationSelector();

  @override
  Widget build(BuildContext context) {
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
                    return const _WarehouseSearchScreen();
                  })
            ,
            child: const _LocationSelectedWarehouse()));
  }
}

class _LocationSelectedWarehouse extends StatelessWidget {
  const _LocationSelectedWarehouse({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectEditorBloc, ProjectEditorState>(
        buildWhen: (previous, current) =>
            previous.warehouse != current.warehouse,
        builder: (context, state) {
          return Container(
            alignment: Alignment.centerLeft,
            height: 50,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('${state.warehouse ?? "Select Warehouse"}',
                      style: const TextStyle(
                          color: Colors.black26,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0)),
                  Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const <Widget>[
                          Icon(Icons.add_location,
                              size: 24.0, color: Colors.black26),
                        ]),
                  )
                ]),
          );
        });
  }
}

class _WarehouseSearchScreen extends StatelessWidget {
  const _WarehouseSearchScreen();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) {
          return WarehouseSearchBloc(
              repository: RepositoryProvider.of<WarehouseRepository>(context),
              warehouseSelectionService: RepositoryProvider.of<WarehouseSelectionService>(context));
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
                      const _CityInput(),
                      const _StateInput(),
                      const _WarehouseSearchButton(),
                      const _ErrorText(),
                      const Expanded(child: _WarehouseList())
                    ])))));
  }
}

class _CityInput extends StatelessWidget {
  const _CityInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WarehouseSearchBloc, WarehouseSearchState>(
      buildWhen: (previous, current) =>
          previous.searchCity != current.searchCity,
      builder: (context, state) {
        TextEditingController? controller;
        if (state.status == FormEditorStatus.dataLoaded) {
          controller = TextEditingController(text: state.searchCity);
        }
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: TextField(
              controller: controller,
              key: const Key('projectWarehouseSearch_cityInput_textField'),
              keyboardType: TextInputType.text,
              onChanged: (searchCity) => context
                  .read<WarehouseSearchBloc>()
                  .add(WarehouseSearchCityChangedEvent(searchCity)),
              decoration: const InputDecoration(
                labelText: 'City',
              ),
            ));
      },
    );
  }
}

class _StateInput extends StatelessWidget {
  const _StateInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WarehouseSearchBloc, WarehouseSearchState>(
      buildWhen: (previous, current) =>
          previous.searchState != current.searchState,
      builder: (context, state) {
        TextEditingController? controller;
        if (state.status == FormEditorStatus.dataLoaded) {
          controller = TextEditingController(text: state.searchState);
        }
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: TextField(
              controller: controller,
              key: const Key('projectWarehouseSearch_stateInput_textField'),
              keyboardType: TextInputType.text,
              onChanged: (searchState) => context
                  .read<WarehouseSearchBloc>()
                  .add(WarehouseSearchStateChangedEvent(searchState)),
              decoration: const InputDecoration(
                labelText: 'State',
              ),
            ));
      },
    );
  }
}

class _WarehouseSearchButton extends StatelessWidget {
  const _WarehouseSearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WarehouseSearchBloc, WarehouseSearchState>(
        builder: (context, state) {
      if (state.status == FormEditorStatus.dataSaved ||
          state.status == FormEditorStatus.cancelled) {
        Navigator.of(context).pop();
        return const Text('');
      } else {
        return Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0),
          child: ElevatedButton(
              onPressed: () {
                context
                    .read<WarehouseSearchBloc>()
                    .add(const WarehouseSearchSubmitChangedEvent());
              },
              child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Search",
                    style: TextStyle(color: Colors.white, fontSize: 24.0),
                  ))),
        );
      }
    });
  }
}

class _WarehouseList extends StatelessWidget {
  const _WarehouseList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WarehouseSearchBloc, WarehouseSearchState>(
        buildWhen: (previous, current) =>
            previous.warehouses != current.warehouses,
        builder: (context, state) {
          return Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
              child: ListView.builder(
                  itemCount: state.warehouses.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: ()  {
                        context
                            .read<WarehouseSearchBloc>()
                            .add(WarehouseSearchSelectionEvent(state.warehouses[index]));
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
                                      title: Text(state.warehouses[index].name),
                                      subtitle: Text(
                                          '${state.warehouses[index].city}, ${state.warehouses[index].state}')),
                                ]))));
                  }));
        });
  }
}

class _ErrorText extends StatelessWidget {
  const _ErrorText({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WarehouseSearchBloc, WarehouseSearchState>(
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

class _SaveButton extends StatelessWidget {
  const _SaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectEditorBloc, ProjectEditorState>(
        builder: (context, state) {
      if (state.status == FormEditorStatus.dataSaved ||
          state.status == FormEditorStatus.cancelled) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
              onPressed: () => context.read<ProjectEditorBloc>().add(const ProjectEditorSaveEvent()),
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
