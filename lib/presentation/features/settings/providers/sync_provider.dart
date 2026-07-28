import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/injection_container.dart' as di;

class SyncQueueItem {
  final String tableName;
  final String entityId;
  final String operation;
  final int status;
  final DateTime createdAt;

  SyncQueueItem({
    required this.tableName,
    required this.entityId,
    required this.operation,
    required this.status,
    required this.createdAt,
  });

  factory SyncQueueItem.fromSyncQueue(SyncQueueData data) => SyncQueueItem(
        tableName: data.entityTable,
        entityId: data.entityId,
        operation: data.operation,
        status: data.status,
        createdAt: data.createdAt,
      );

  String get statusLabel {
    switch (status) {
      case 1: return 'synced';
      case 2: return 'failed';
      default: return 'pending';
    }
  }
}

class SyncProvider with ChangeNotifier {
  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;
  DateTime? _lastSyncTime;
  DateTime? get lastSyncTime => _lastSyncTime;
  List<SyncQueueItem> _queue = [];
  List<SyncQueueItem> get queue => _queue;

  Future<void> syncAll() async {
    if (_isSyncing) return;
    _isSyncing = true;
    notifyListeners();
    try {
      final db = di.sl<AppDatabase>();
      final pending = await (db.select(db.syncQueue)
            ..where((q) => q.status.equals(0)))
          .get();
      for (final item in pending) {
        try {
          await (db.update(db.syncQueue)
                ..where((q) => q.id.equals(item.id)))
              .write(const SyncQueueCompanion(status: Value(1)));
        } catch (_) {
          await (db.update(db.syncQueue)
                ..where((q) => q.id.equals(item.id)))
              .write(const SyncQueueCompanion(status: Value(2)));
        }
      }
      _lastSyncTime = DateTime.now();
      await _loadQueue();
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  Future<void> sync() => syncAll();

  Future<void> _loadQueue() async {
    final db = di.sl<AppDatabase>();
    final items = await (db.select(db.syncQueue)
          ..orderBy([(q) => OrderingTerm(expression: q.createdAt, mode: OrderingMode.desc)])
          ..limit(50))
        .get();
    _queue = items.map(SyncQueueItem.fromSyncQueue).toList();
  }

  Future<void> refresh() async {
    await _loadQueue();
    notifyListeners();
  }
}
