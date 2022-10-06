import 'dart:async';
import 'package:flutter_cbl_learning_path/models/warehouse.dart';

class WarehouseSelectionService {
  WarehouseSelectionService();

  late StreamController<Warehouse?>? _controller;

  void init() => _controller = StreamController<Warehouse?>();

  void dispose() => _controller?.close();

  Stream<Warehouse?> get warehouse async* {
    if (_controller != null) {
      yield* _controller!.stream;
    }
  }

  void setWarehouse(Warehouse warehouse){
    _controller?.add(warehouse);
  }
}
