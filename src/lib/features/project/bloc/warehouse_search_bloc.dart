import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_cbl_learning_path/models/models.dart';

import 'package:flutter_cbl_learning_path/features/project/bloc/warehouse_search_event.dart';
import 'package:flutter_cbl_learning_path/features/project/bloc/warehouse_search_state.dart';
import 'package:flutter_cbl_learning_path/features/project/data/warehouse_repository.dart';
import 'package:flutter_cbl_learning_path/models/form_status.dart';

import '../services/warehouse_selected_service.dart';

class WarehouseSearchBloc extends Bloc<WarehouseSearchEvent, WarehouseSearchState>{
  WarehouseSearchBloc({required WarehouseRepository repository, required WarehouseSelectionService warehouseSelectionService}) : _repository = repository,
  _warehouseSelectionService = warehouseSelectionService, super(const WarehouseSearchState()) {
    on<WarehouseSearchCityChangedEvent>(_onCityChanged);
    on<WarehouseSearchStateChangedEvent>(_onStateChanged);
    on<WarehouseSearchSubmitChangedEvent>(_onSubmitted);
    on<WarehouseSearchSelectionEvent>(_onSelection);
  }
  final WarehouseRepository _repository;
  final WarehouseSelectionService _warehouseSelectionService;

  FutureOr<void> _onCityChanged(WarehouseSearchCityChangedEvent event, Emitter<WarehouseSearchState> emit) {
    emit(state.copyWith(searchCity: event.searchCity, status: FormEditorStatus.dataChanged));
  }

  FutureOr<void> _onStateChanged(WarehouseSearchStateChangedEvent event, Emitter<WarehouseSearchState> emit) {
    emit(state.copyWith(searchState: event.searchState, status: FormEditorStatus.dataChanged));
  }

  FutureOr<void> _onSubmitted(WarehouseSearchSubmitChangedEvent event, Emitter<WarehouseSearchState> emit) async {
    if (state.searchCity.isNotEmpty){
      //get warehouse list from repository
      try {
        var items = await _repository.search(state.searchCity, state.searchState);
        if (items.isNotEmpty) {
          emit(state.copyWith(error: '',
              status: FormEditorStatus.dataLoaded,
              warehouses: items));
        } else {
          emit(state.copyWith(error: 'No warehouses found matching criteria.', status: FormEditorStatus.error));
        }

      } catch (e){
        emit(state.copyWith(error: e.toString(), status: FormEditorStatus.error));
      }
    }
    else {
      emit(state.copyWith(error: 'Error - City can\'t be blank', status: FormEditorStatus.error));
    }
  }

  FutureOr<void> _onSelection(WarehouseSearchSelectionEvent event, Emitter<WarehouseSearchState> emit) async {
    var warehouse = event.item;
    if (warehouse != null){
      try {
        _warehouseSelectionService.setWarehouse(warehouse);
      } catch (e){
        emit(state.copyWith(error: e.toString(), status: FormEditorStatus.error));
      }
    } else {
      emit(state.copyWith(error: 'Warehouse should not be null when selected, but is for some strange reason.', status: FormEditorStatus.error));
    }
  }

}
