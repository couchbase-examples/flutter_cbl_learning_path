import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_cbl_learning_path/models/models.dart';
import 'package:intl/intl.dart';

import 'package:flutter_cbl_learning_path/features/project/bloc/warehouse_search_event.dart';
import 'package:flutter_cbl_learning_path/features/project/bloc/warehouse_search_state.dart';
import 'package:flutter_cbl_learning_path/features/project/data/warehouse_repository.dart';
import 'package:flutter_cbl_learning_path/models/form_status.dart';

class WarehouseSearchBloc extends Bloc<WarehouseSearchEvent, WarehouseSearchState>{
  WarehouseSearchBloc({required WarehouseRepository repository}) : _repository = repository,
  super(const WarehouseSearchState()) {
    on<WarehouseSearchCityChangedEvent>(_onCityChanged);
    on<WarehouseSearchStateChangedEvent>(_onStateChanged);
    on<WarehouseSearchSubmitChangedEvent>(_onSubmitted);
  }

  final WarehouseRepository _repository;

  FutureOr<void> _onCityChanged(WarehouseSearchCityChangedEvent event, Emitter<WarehouseSearchState> emit) {
    emit(state.copyWith(searchCity: event.searchCity, status: FormEditorStatus.dataChanged));
  }

  FutureOr<void> _onStateChanged(WarehouseSearchStateChangedEvent event, Emitter<WarehouseSearchState> emit) {
    emit(state.copyWith(searchCity: event.searchState, status: FormEditorStatus.dataChanged));
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
}
