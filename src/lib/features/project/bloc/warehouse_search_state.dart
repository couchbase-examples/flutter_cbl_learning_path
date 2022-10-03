import 'package:equatable/equatable.dart';
import 'package:flutter_cbl_learning_path/models/form_status.dart';
import '../../../models/warehouse.dart';

class WarehouseSearchState extends Equatable {
  const WarehouseSearchState(
  {
    this.status = FormEditorStatus.dataUninitialized,
    this.searchCity = '',
    this.searchState = '',
    this.error = '',
    this.selectedWarehouse

  });
  final FormEditorStatus status;
  final String searchCity;
  final String searchState;
  final String error;
  final Warehouse? selectedWarehouse;

  WarehouseSearchState copyWith({
    FormEditorStatus? status,
    String? searchCity,
    String? searchState,
    String? error,
    Warehouse? selectedWarehouse})
  {
    return WarehouseSearchState(
      status: status ?? this.status,
      searchCity: searchCity ?? this.searchCity,
      searchState: searchState ?? this.searchState,
      error: error ?? this.error,
      selectedWarehouse: selectedWarehouse ?? this.selectedWarehouse
      );
  }

  @override
  List<Object?> get props =>
      [status, searchCity, searchState, error, selectedWarehouse];
}