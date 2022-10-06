import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cbl_learning_path/features/audit/data/audit_repository.dart';
import 'package:flutter_cbl_learning_path/features/audit/data/stock_item_repository.dart';
import 'package:flutter_cbl_learning_path/features/project/data/project_repository.dart';
import 'package:flutter_cbl_learning_path/features/project/data/warehouse_repository.dart';
import 'package:flutter_cbl_learning_path/features/router/route.dart';
import 'package:flutter_cbl_learning_path/features/developer/models/dev_info.dart';
import 'package:flutter_cbl_learning_path/features/developer/bloc/dev_info_event.dart';
import 'package:flutter_cbl_learning_path/features/developer/bloc/dev_info_state.dart';

class DevInfoBloc extends Bloc<DevInfoEvent, DevInfoState> {
  final FakeAuthenticationService _authenticationService;
  final ProjectRepository _projectRepository;
  final AuditRepository _auditRepository;
  final WarehouseRepository _warehouseRepository;
  final StockItemRepository _stockItemRepository;

  DevInfoBloc({
    required FakeAuthenticationService authenticationService,
    required ProjectRepository projectRepository,
    required AuditRepository auditRepository,
    required WarehouseRepository warehouseRepository,
    required StockItemRepository stockItemRepository,
  })  : _authenticationService = authenticationService,
        _projectRepository = projectRepository,
        _auditRepository = auditRepository,
        _warehouseRepository = warehouseRepository,
        _stockItemRepository = stockItemRepository,
        super(const DevInfoState(status: DevInfoStatus.uninitialized)) {
    on<DevInfoInitializeEvent>(_initialize);
  }

  Future<void> _initialize(
      DevInfoEvent event, Emitter<DevInfoState> emit) async {
    try {
      //start loading data into collection
      var state = const DevInfoState(status: DevInfoStatus.loading);
      emit(state);
      List<DeveloperInfo> items = [];
      //get user
      var user = await _authenticationService.getCurrentUser();
      if (user != null) {
        //get counters
        var projectCounter = await _projectRepository.count();
        var auditCounter = await _auditRepository.count();
        var warehouseCounter = await _warehouseRepository.count();
        var stockItemCounter = await _stockItemRepository.count();

        //get database information
        var inventoryName = _projectRepository.getDatabaseName();
        var inventoryPath = _projectRepository.getDatabasePath();
        var warehouseName = _warehouseRepository.getDatabaseName();
        var warehousePath = _warehouseRepository.getDatabasePath();
        items.add(DeveloperInfo(title: 'Username', details: user.username));
        items.add(DeveloperInfo(title: 'Team', details: user.team));
        items.add(DeveloperInfo(
            title: 'Inventory Database Path', details: inventoryPath));
        items.add(DeveloperInfo(
            title: 'Inventory Database Name', details: inventoryName));
        items.add(DeveloperInfo(
            title: 'Project Document Count',
            details: projectCounter.toString()));
        items.add(DeveloperInfo(
            title: 'Audit Document Count', details: auditCounter.toString()));
        items.add(DeveloperInfo(
            title: 'Warehouse Database Path', details: warehousePath));
        items.add(DeveloperInfo(
            title: 'Warehouse Database Name', details: warehouseName));
        items.add(DeveloperInfo(
            title: 'Warehouse Document Count',
            details: warehouseCounter.toString()));
        items.add(DeveloperInfo(
            title: 'Stock Item Document Count',
            details: stockItemCounter.toString()));
        var success = state.copyWith(DevInfoStatus.success, items, user, '');
        emit(success);
      } else {
        var error = state.copyWith(
            DevInfoStatus.fail, null, null, 'Error: could not get user');
        emit(error);
      }
    } catch (e) {
      var error = state.copyWith(DevInfoStatus.fail, null, null, e.toString());
      emit(error);
      debugPrint(e.toString());
    }
  }
}
