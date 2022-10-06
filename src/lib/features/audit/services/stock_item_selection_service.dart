import 'dart:async';
import '../../../models/stock_item.dart';

class StockItemSelectionService {
  StockItemSelectionService();

  late StreamController<StockItem?>? _controller;

  void init() => _controller = StreamController<StockItem?>();

  void dispose() => _controller?.close();

  Stream<StockItem?> get stockItem async* {
    if (_controller != null){
      yield* _controller!.stream;
    }
  }

  void setStockItem(StockItem stockItem){
    _controller?.add(stockItem);
  }
}