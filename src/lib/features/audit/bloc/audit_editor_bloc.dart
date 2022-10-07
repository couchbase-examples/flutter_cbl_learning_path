import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_cbl_learning_path/features/audit/data/audit_repository.dart';
import 'package:flutter_cbl_learning_path/features/audit/services/stock_item_selection_service.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter_cbl_learning_path/features/router/route.dart';
import 'package:flutter_cbl_learning_path/models/models.dart';
import 'package:flutter_cbl_learning_path/features/audit/bloc/audit_editor.dart';

class AuditEditorBloc extends Bloc<AuditEditorEvent, AuditEditorState> {
  //constructor
  AuditEditorBloc({
      required AuditRepository auditRepository,
      required AuthenticationService authenticationService,
      required RouterService routerService,
      required StockItemSelectionService stockItemSelectionService,
      required String projectId,
      required Audit? audit})
      : _auditRepository = auditRepository,
        _routerService = routerService,
        _authenticationService = authenticationService,
        _stockItemSelectionService = stockItemSelectionService,
        _projectId = projectId,
        _audit = audit,
        super(const AuditEditorState()) {

    //register for listening to events
    on<AuditEditorInitialAuditLoadedEvent>(_onInitialized);
    on<AuditEditorNotesChangedEvent>(_onNotesChanged);
    on<AuditEditorCountChangedEvent>(_onCountChanged);
    on<AuditEditorStockItemChangedEvent>(_onStockItemChanged);
    on<AuditEditorSaveEvent>(_onSave);

    _stockItemSelectionService.init();
    if (_audit != null){
      var audit = _audit!;
      add(AuditEditorInitialAuditLoadedEvent(audit));
    }
    //register for listening to streams from service
    _stockItemSelectionSubscription =
        _stockItemSelectionService.stockItem.listen(
      (item) => add(AuditEditorStockItemChangedEvent(item)),
    );
  }

  final AuditRepository _auditRepository;
  final AuthenticationService _authenticationService;
  final StockItemSelectionService _stockItemSelectionService;
  final RouterService _routerService;
  final String _projectId;
  final Audit? _audit;

  late StreamSubscription<StockItem?> _stockItemSelectionSubscription;

  @override
  Future<void> close() async {
    super.close();
    await _stockItemSelectionSubscription.cancel();
    _stockItemSelectionService.dispose();
  }

  FutureOr<void> _onInitialized(
      AuditEditorInitialAuditLoadedEvent event,
      Emitter<AuditEditorState> emit) {
    emit(state.copyWith(
      notes: event.audit.notes,
      auditCount: event.audit.auditCount,
      stockItem: event.audit.stockItem,
      status: FormEditorStatus.dataLoaded
    ));

  }

  FutureOr<void> _onNotesChanged(
      AuditEditorNotesChangedEvent event, Emitter<AuditEditorState> emit) {
    emit(state.copyWith(
        notes: event.notes, status: FormEditorStatus.dataChanged));
  }

  FutureOr<void> _onCountChanged(
      AuditEditorCountChangedEvent event, Emitter<AuditEditorState> emit) {
    emit(state.copyWith(
        auditCount: event.auditCount, status: FormEditorStatus.dataChanged));
  }

  FutureOr<void> _onStockItemChanged(
      AuditEditorStockItemChangedEvent event, Emitter<AuditEditorState> emit) {
    emit(state.copyWith(
        stockItem: event.stockItem, status: FormEditorStatus.dataChanged));
  }

  FutureOr<void> _onSave(
      AuditEditorSaveEvent event, Emitter<AuditEditorState> emit) async {
    try {
      if (state.stockItem == null) {
        emit(state.copyWith(status: FormEditorStatus.error, error: 'error: stock item must be selected'));
      } else {
        //get auditId
        String auditId;
        if (_audit?.auditId != null && _audit?.auditId != null) {
          auditId = _audit!.auditId;
        } else {
          var uuid = const Uuid();
          auditId = uuid.v4().toString();
        }
        var currentUser = await _authenticationService.getCurrentUser();
        if (currentUser != null) {
          var document = Audit(
            auditId: auditId,
            projectId: _projectId,
            notes: state.notes ?? '',
            auditCount: state.auditCount,
            stockItem: state.stockItem,
            team: currentUser.team,
            createdBy: _audit?.createdBy ?? currentUser.username,
            modifiedBy: currentUser.username,
            createdOn: _audit?.createdOn ?? DateTime.now(),
            modifiedOn: DateTime.now(),
          );
          var didSave = await _auditRepository.save(document);
          if (didSave){
            emit(state.copyWith(status: FormEditorStatus.dataSaved));
            _routerService.routeTo(const ScreenRoute(routeToScreen: RouteToScreen.pop));
          } else {
            emit(state.copyWith(status: FormEditorStatus.error, error: 'Tried to save audit, repository returned false for save status.'));
          }
        }
      }
    } catch (e) {
      emit(state.copyWith(status: FormEditorStatus.error, error: e.toString()));
      debugPrint(e.toString());
    }
  }
}
