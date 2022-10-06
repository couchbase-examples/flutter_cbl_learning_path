import 'package:equatable/equatable.dart';
import 'package:flutter_cbl_learning_path/models/models.dart';

abstract class AuditEditorEvent extends Equatable {
  const AuditEditorEvent();

  @override
  List<Object?> get props => [];
}

class AuditEditorNotesChangedEvent extends AuditEditorEvent {
  const AuditEditorNotesChangedEvent(this.notes);

  final String notes;

  @override
  List<Object?> get props => [notes];
}

class AuditEditorCountChangedEvent extends AuditEditorEvent {
  const AuditEditorCountChangedEvent(this.auditCount);

  final int auditCount;

  @override
  List<Object?> get props => [auditCount];
}

class AuditEditorStockItemChangedEvent extends AuditEditorEvent {
  const AuditEditorStockItemChangedEvent(this.stockItem);

  final StockItem? stockItem;

  @override
  List<Object?> get props => [stockItem];
}

class AuditEditorSaveEvent extends AuditEditorEvent {
  const AuditEditorSaveEvent();
}

class AuditEditorInitialAuditLoadedEvent extends AuditEditorEvent {
  const AuditEditorInitialAuditLoadedEvent(this.audit);

  final Audit audit;

  @override
  List<Object?> get props => [audit];
}