import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_cbl_learning_path/models/models.dart';

import 'package:flutter_cbl_learning_path/features/audit/bloc/stockitem_search_event.dart';
import 'package:flutter_cbl_learning_path/features/audit/bloc/stockitem_search_state.dart';
import 'package:flutter_cbl_learning_path/features/audit/data/stock_item_repository.dart';
import 'package:flutter_cbl_learning_path/models/form_status.dart';

import '../services/stock_item_selection_service.dart';

class StockItemSearchBloc
    extends Bloc<StockItemSearchEvent, StockItemSearchState> {
  StockItemSearchBloc(
      {required StockItemRepository repository,
      required StockItemSelectionService stockItemSelectionService})
      : _repository = repository,
        _stockItemSelectionService = stockItemSelectionService,
        super(const StockItemSearchState()) {
    on<StockItemSearchNameChangedEvent>(_onNameChanged);
    on<StockItemSearchDescriptionChangedEvent>(_onDescriptionChanged);
    on<StockItemSearchSubmitChangedEvent>(_onSubmitted);
    on<StockItemSearchSelectionEvent>(_onSelection);
  }

  final StockItemRepository _repository;
  final StockItemSelectionService _stockItemSelectionService;

  FutureOr<void> _onNameChanged(StockItemSearchNameChangedEvent event,
      Emitter<StockItemSearchState> emit) {
    emit(state.copyWith(searchName: event.searchName, status: FormEditorStatus.dataChanged));
  }

  FutureOr<void> _onDescriptionChanged(
      StockItemSearchDescriptionChangedEvent event,
      Emitter<StockItemSearchState> emit) {
    emit(state.copyWith(searchDescription: event.searchDescription, status: FormEditorStatus.dataChanged));
  }

  FutureOr<void> _onSubmitted(StockItemSearchSubmitChangedEvent event,
      Emitter<StockItemSearchState> emit) async {
    if (state.searchName.isNotEmpty){
      try {
        var items = await _repository.search(state.searchName, state.searchDescription);
        if (items.isNotEmpty){
          emit(state.copyWith(error: '', status: FormEditorStatus.dataLoaded, items: items));
        } else {
          emit(state.copyWith(error: 'No stock items found matching criteria.', status: FormEditorStatus.error));
        }
      } catch (e){
        emit(state.copyWith(error: e.toString(), status: FormEditorStatus.error));
      }
    } else {
      emit(state.copyWith(error: 'Error - Search Name can\'t be blank', status: FormEditorStatus.error));
    }
  }

  FutureOr<void> _onSelection(StockItemSearchSelectionEvent event,
      Emitter<StockItemSearchState> emit) {
    var stockItem = event.item;
    if (stockItem != null){
      try {
        _stockItemSelectionService.setStockItem(stockItem);
      } catch (e){
        emit(state.copyWith(error: e.toString(), status: FormEditorStatus.error));
      }
    } else {
      emit(state.copyWith(error: 'StockItem should not be null when selected, but is for some strange reason.', status: FormEditorStatus.error));
    }
  }
}
