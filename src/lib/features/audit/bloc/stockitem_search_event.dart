import 'package:equatable/equatable.dart';
import 'package:flutter_cbl_learning_path/models/models.dart';

abstract class StockItemSearchEvent extends Equatable {
  const StockItemSearchEvent();

  @override
  List<Object?> get props => [];
}

class StockItemSearchNameChangedEvent extends StockItemSearchEvent{
  const StockItemSearchNameChangedEvent(this.searchName);

  final String searchName;

  @override
  List<Object> get props => [searchName];
}

class StockItemSearchDescriptionChangedEvent extends StockItemSearchEvent{
  const StockItemSearchDescriptionChangedEvent(this.searchDescription);

  final String searchDescription;

  @override
  List<Object> get props => [searchDescription];
}

class StockItemSearchSubmitChangedEvent extends StockItemSearchEvent{
  const StockItemSearchSubmitChangedEvent();

  @override
  List<Object> get props => [];
}

class StockItemSearchSelectionEvent extends StockItemSearchEvent{
  const StockItemSearchSelectionEvent(this.item);

  final StockItem? item;

  @override
  List<Object?> get props => [item];
}
