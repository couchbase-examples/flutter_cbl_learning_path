import 'dart:async';

import '../../../models/warehouse.dart';

class WarehouseSelectionService {
  WarehouseSelectionService();

  final _controller = StreamController<Warehouse>();

  void dispose() => _controller.close();

  Stream<Warehouse?> get warehouse async* {
    yield* _controller.stream;
  }

  void setWarehouse(Warehouse warehouse){
    _controller.add(warehouse);
  }
}
