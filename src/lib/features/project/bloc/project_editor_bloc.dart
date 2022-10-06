import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_cbl_learning_path/features/project/services/warehouse_selected_service.dart';
import 'package:flutter_cbl_learning_path/features/router/route.dart';
import 'package:flutter_cbl_learning_path/features/project/bloc/project_editor.dart';
import 'package:flutter_cbl_learning_path/features/project/data/project_repository.dart';
import 'package:flutter_cbl_learning_path/models/models.dart';

class ProjectEditorBloc extends Bloc<ProjectEditorEvent, ProjectEditorState> {
  //constructor
  ProjectEditorBloc({
    required ProjectRepository projectRepository,
    required AuthenticationService authenticationService,
    required RouterService routerService,
    required WarehouseSelectionService warehouseSelectionService})
      : _projectRepository = projectRepository,
        _routerService = routerService,
        _warehouseSelectionService = warehouseSelectionService,
        _authenticationService = authenticationService,
        super(const ProjectEditorState()) {

    //register for listening to events
    on<ProjectEditorNameChangedEvent>(_onNameChanged);
    on<ProjectEditorDescriptionChangedEvent>(_onDescriptionChanged);
    on<ProjectEditorDueDateChangeEvent>(_onDueDateChange);
    on<ProjectEditorDueDateChangedEvent>(_onDueDateChanged);
    on<ProjectEditorWarehouseChangedEvent>(_onWarehouseChanged);
    on<ProjectEditorInitialProjectLoadingEvent>(_onInitialization);
    on<ProjectEditorSaveEvent>(_onSave);

    _warehouseSelectionService.init();

    //register for listening to streams from services
   _warehouseSelectionSubscription = _warehouseSelectionService.warehouse.listen(
      (item) => add(ProjectEditorWarehouseChangedEvent(item)),
    );
  }

  final ProjectRepository _projectRepository;
  final AuthenticationService _authenticationService;
  final WarehouseSelectionService _warehouseSelectionService;
  final RouterService _routerService;

  late StreamSubscription<Warehouse?> _warehouseSelectionSubscription;

  @override
  Future<void> close() async{
    super.close();
    await _warehouseSelectionSubscription.cancel();
    _warehouseSelectionService.dispose();
  }

  FutureOr<void> _onNameChanged(
      ProjectEditorNameChangedEvent event, Emitter<ProjectEditorState> emit) {
    emit(state.copyWith(name: event.name, status: FormEditorStatus.dataChanged));
  }

  FutureOr<void> _onDescriptionChanged(ProjectEditorDescriptionChangedEvent event,
      Emitter<ProjectEditorState> emit) {
    emit(state.copyWith(description: event.description, status: FormEditorStatus.dataChanged));
  }

  Future<void> _onDueDateChange  (
      ProjectEditorDueDateChangeEvent event, Emitter<ProjectEditorState> emit) async {
    var dateSelected = await event.dueDate;
    if (dateSelected != null) {
      final DateFormat formatter = DateFormat("yyyy-MM-dd");
      add(ProjectEditorDueDateChangedEvent(formatter.format(dateSelected)));
    }
  }

  FutureOr<void> _onDueDateChanged(
      ProjectEditorDueDateChangedEvent event,
      Emitter<ProjectEditorState> emit) {
    emit(state.copyWith(dueDate: event.dateSelected, status: FormEditorStatus.dataChanged));
  }

  FutureOr<void> _onWarehouseChanged(
      ProjectEditorWarehouseChangedEvent event, Emitter<ProjectEditorState> emit) {
    emit(state.copyWith(warehouse: event.warehouse, status: FormEditorStatus.dataChanged));
  }

  FutureOr<void> _onInitialization(ProjectEditorInitialProjectLoadingEvent event,
      Emitter<ProjectEditorState> emit) async {
    try {
      final project = await _projectRepository.get(event.projectId);
      if (project.name.isNotEmpty) {
        emit(state.copyWith(
            status: FormEditorStatus.dataLoaded,
            name: project.name,
            description: project.description,
            dueDate: project.dueDateToString(),
            warehouse: project.warehouse));
      }
    } catch (e) {
      emit(state.copyWith(status: FormEditorStatus.error, error: e.toString()));
      debugPrint(e.toString());
    }
  }

  FutureOr<void> _onSave(ProjectEditorSaveEvent event, Emitter<ProjectEditorState> emit) async {
    try {
      var uuid = const Uuid();
      var currentUser = await _authenticationService.getCurrentUser();
      if (currentUser != null) {
        var document = Project(
            projectId: uuid.v4().toString(),
            name: state.name,
            description: state.description,
            isComplete: false,
            dueDate: DateTime.parse(state.dueDate),
            warehouse: state.warehouse,
            team: currentUser.team,
            createdBy: currentUser.username,
            modifiedBy: currentUser.username,
            createdOn: DateTime.now(),
            modifiedOn: DateTime.now());
        var didSave = await _projectRepository.save(document);
        if (didSave) {
          emit(state.copyWith(status: FormEditorStatus.dataSaved));
          _routerService.routeTo(const ScreenRoute(routeToScreen: RouteToScreen.pop));
        }
        else {
          emit(state.copyWith(status: FormEditorStatus.error, error: 'Tried to save project, repository returned false for save status.'));
        }
      } else {
        emit(state.copyWith(status: FormEditorStatus.error, error: 'Can\'t save project because current user is null.  This state should never happen.'));
      }
    } catch (e){
      emit(state.copyWith(status: FormEditorStatus.error, error: e.toString()));
      debugPrint(e.toString());
    }
  }
}
