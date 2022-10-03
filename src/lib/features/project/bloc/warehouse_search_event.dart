import 'package:equatable/equatable.dart';
import 'package:flutter_cbl_learning_path/models/models.dart';

abstract class WarehouseSearchEvent extends Equatable {
  const WarehouseSearchEvent ();

  @override
  List<Object?> get props => [];
}

class WarehouseSearchCityChangedEvent extends WarehouseSearchEvent{
  const WarehouseSearchCityChangedEvent(this.searchCity);

  final String searchCity;

  @override
  List<Object> get props => [searchCity];
}

class WarehouseSearchStateChangedEvent extends WarehouseSearchEvent{
  const WarehouseSearchStateChangedEvent(this.searchState);

  final String searchState;

  @override
  List<Object> get props => [searchState];
}

class WarehouseSearchSubmitChangedEvent extends WarehouseSearchEvent{
  const WarehouseSearchSubmitChangedEvent();

  @override
  List<Object> get props => [];
}

class WarehouseSearchResultsEvent extends WarehouseSearchEvent {
  const WarehouseSearchResultsEvent(this.items, this.error);

  final List<Warehouse>? items;
  final String? error;

  @override
  List<Object?> get props => [items, error];
}
