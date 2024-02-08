import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cbl_learning_path/features/audit/data/audit_repository.dart';
import 'audit_list.dart';

import '../../../models/models.dart';
import '../../../models/audit_dao.dart';


class AuditListBloc extends Bloc<AuditListEvent, AuditListState> {
  AuditListBloc({required AuditRepository repository})
      : _repository = repository,
        super(const AuditListState()) {
    on<AuditListInitializeEvent>(_onInitialize);
    on<AuditListLoadedEvent>(_onLoaded);
  }

  final AuditRepository _repository;
  var isInitialState = true;
  var _isClosed = false;

  @override
  Future<void> close() {
    _isClosed = true;
    return super.close();
  }

  Future<void> _onLoaded(
      AuditListLoadedEvent event, Emitter<AuditListState> emit) async {

    var items = event.items;

    //if first time loading, then return loaded status, otherwise return changed status
    //this allows UI to react better to changes vs initial load and allows building
    //of a better user experience

    // <1>
    if (items.isNotEmpty && isInitialState){
      isInitialState = false;
      emit(state.copyWith(status: DataStatus.loaded, items: items, error: ''));
      // <2>
    } else if (items.isNotEmpty && !isInitialState){
      emit(state.copyWith(status: DataStatus.changed, items: items, error: ''));
      // <3>
    } else {
      emit(state.copyWith(status: DataStatus.empty));
    }
  }


  Future<void> _onInitialize (
      AuditListInitializeEvent event, Emitter<AuditListState> emit) async {
    try {
      emit(state.copyWith(status: DataStatus.loading));
      // <1>
      var stream = await _repository.getDocuments(event.projectId);
      // <2>
      if (stream != null) {
        // <3>
        stream.listen((change) async {
          // <4>
          var items = <Audit>[];
          // <5>
          var results = await change.results.allResults();
          if (!_isClosed) {
            //<6>
            for (var result in results) {
              // <7>
              var map = result.toPlainMap();
              var dao = AuditDao.fromJson(map);
              // <8>
              items.add(dao.item);
            }
            // <9>
            add(AuditListLoadedEvent(items: items));
          }
        });
      }
    } catch (e) {
      emit(state.copyWith(status: DataStatus.error, error: e.toString()));
      debugPrint(e.toString());
    }
  }
}
