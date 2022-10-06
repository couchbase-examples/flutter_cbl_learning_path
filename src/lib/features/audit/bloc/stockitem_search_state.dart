import 'package:equatable/equatable.dart';
import 'package:flutter_cbl_learning_path/models/form_status.dart';
import '../../../models/stock_item.dart';

class StockItemSearchState extends Equatable {
  const StockItemSearchState({
    this.status = FormEditorStatus.dataUninitialized,
    this.searchName = '',
    this.searchDescription = '',
    this.error = '',
    this.items = const <StockItem>[],
    this.selectedStockItem
  });

  final FormEditorStatus status;
  final String searchName;
  final String searchDescription;
  final String error;
  final List<StockItem> items;
  final StockItem? selectedStockItem;

  StockItemSearchState copyWith({
    FormEditorStatus? status,
    String? searchName,
    String? searchDescription,
    String? error,
    List<StockItem>? items,
    StockItem? selectedStockItem}){
    return StockItemSearchState(
      status: status ?? this.status,
      searchName: searchName ?? this.searchName,
      searchDescription: searchDescription ?? this.searchDescription,
      error: error ?? this.error,
      items: items ?? this.items,
      selectedStockItem: selectedStockItem ?? this.selectedStockItem
    );
  }

  @override
  List<Object?> get props => [status, searchName, searchDescription, error, items, selectedStockItem];
}