import 'package:equatable/equatable.dart';
import '../../../models/models.dart';

class AuditEditorState extends Equatable {
  const AuditEditorState(
      {this.status = FormEditorStatus.dataUninitialized,
        this.notes = '',
        this.auditCount = 0,
        this.error = '',
        this.stockItem});

  final FormEditorStatus status;
  final String? notes;
  final int auditCount;
  final String? error;

  final StockItem? stockItem;

  AuditEditorState copyWith(
      {FormEditorStatus? status,
        Audit? audit,
        String? projectId,
        String? notes,
        int? auditCount,
        String? error,
        StockItem? stockItem}) {
    return AuditEditorState(
        status: status ?? this.status,
        notes: notes ?? this.notes,
        auditCount: auditCount ?? this.auditCount,
        error: error ?? this.error,
        stockItem: stockItem ?? this.stockItem);
  }

  @override
  List<Object?> get props =>
      [status, notes, auditCount, error, stockItem];
}
