import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:supermarket/core/services/audit_log_service.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:drift/drift.dart';

enum SyncDirection { push, pull, both }

enum ConflictStrategy { serverWins, clientWins, lastWriteWins, manual }

class SyncService {
  final AppDatabase db;
  final AuditLogService? auditLogService;
  final http.Client _httpClient;
  Timer? _syncTimer;
  bool _isSyncing = false;
  SyncDirection _direction = SyncDirection.both;
  ConflictStrategy _conflictStrategy = ConflictStrategy.lastWriteWins;
  String _serverUrl = '';
  String? _authToken;
  DateTime? _lastSyncTime;

  bool get isSyncing => _isSyncing;
  SyncDirection get direction => _direction;
  ConflictStrategy get conflictStrategy => _conflictStrategy;
  String get serverUrl => _serverUrl;
  bool get isConfigured => _serverUrl.isNotEmpty;

  SyncService(this.db, {this.auditLogService, http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  void configure(String serverUrl, {String? authToken}) {
    _serverUrl = serverUrl.endsWith('/')
        ? serverUrl.substring(0, serverUrl.length - 1)
        : serverUrl;
    _authToken = authToken;
  }

  void setDirection(SyncDirection dir) => _direction = dir;
  void setConflictStrategy(ConflictStrategy strategy) =>
      _conflictStrategy = strategy;

  void startAutoSync({Duration interval = const Duration(minutes: 5)}) {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(interval, (_) => syncWithCloud());
  }

  void stopAutoSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  Future<void> addToQueue({
    required String table,
    required String entityId,
    required String operation,
    required Map<String, dynamic> payload,
  }) async {
    final encodedPayload = jsonEncode(payload);
    await db.transaction(() async {
      final existing = await (db.select(db.syncQueue)
            ..where((q) => q.entityTable.equals(table))
            ..where((q) => q.entityId.equals(entityId))
            ..where((q) => q.operation.equals(operation))
            ..where((q) => q.status.equals(0) | q.status.equals(-1)))
          .getSingleOrNull();

      if (existing != null) {
        await (db.update(db.syncQueue)..where((q) => q.id.equals(existing.id)))
            .write(
          SyncQueueCompanion(
            payload: Value(encodedPayload),
            status: const Value(0),
            lastError: const Value(null),
          ),
        );
        return;
      }

      await db.into(db.syncQueue).insert(
            SyncQueueCompanion.insert(
              entityTable: table,
              entityId: entityId,
              operation: operation,
              payload: encodedPayload,
              status: const Value(0),
              version: const Value(1),
              retryCount: const Value(0),
            ),
          );
    });
  }

  Future<List<SyncQueueData>> getPendingItems({int limit = 100}) {
    return (db.select(db.syncQueue)
          ..where((t) => t.status.equals(0) | t.status.equals(-1))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)])
          ..limit(limit))
        .get();
  }

  Future<int> getPendingCount() async {
    final result = await db
        .customSelect(
          "SELECT COUNT(*) as cnt FROM sync_queue WHERE status = 0 OR status = -1",
        )
        .getSingle();
    return result.data['cnt'] as int;
  }

  Future<int> getFailedCount() async {
    final result = await db
        .customSelect(
          "SELECT COUNT(*) as cnt FROM sync_queue WHERE status = -1",
        )
        .getSingle();
    return result.data['cnt'] as int;
  }

  Future<void> markAsSynced(String queueId) async {
    await (db.update(db.syncQueue)..where((t) => t.id.equals(queueId))).write(
      const SyncQueueCompanion(
        status: Value(1),
        retryCount: Value(0),
        lastError: Value(null),
      ),
    );
    if (auditLogService != null) {
      final item = await (db.select(db.syncQueue)
            ..where((t) => t.id.equals(queueId)))
          .getSingleOrNull();
      if (item != null) {
        await auditLogService!.logAction(
          userId: 'system',
          action: 'SYNC_PUSH_SUCCESS',
          logTableName: item.entityTable,
          recordId: item.entityId,
          newValues: {
            'operation': item.operation,
            'queueId': item.id,
          },
        );
      }
    }
  }

  Future<void> markAsFailed(String queueId, String error) async {
    final item = await (db.select(db.syncQueue)
          ..where((t) => t.id.equals(queueId)))
        .getSingle();
    final newRetryCount = item.retryCount + 1;
    final newStatus = newRetryCount >= 5 ? -2 : -1;

    await (db.update(db.syncQueue)..where((t) => t.id.equals(queueId))).write(
      SyncQueueCompanion(
        status: Value(newStatus),
        retryCount: Value(newRetryCount),
        lastError: Value(error),
      ),
    );
    if (auditLogService != null) {
      await auditLogService!.logAction(
        userId: 'system',
        action: 'SYNC_PUSH_FAILED',
        logTableName: item.entityTable,
        recordId: item.entityId,
        newValues: {
          'operation': item.operation,
          'error': error,
          'retryCount': newRetryCount,
        },
      );
    }
  }

  Future<void> retryFailed() async {
    final failed = await (db.select(db.syncQueue)
          ..where((t) => t.status.equals(-1)))
        .get();

    for (final item in failed) {
      await (db.update(db.syncQueue)..where((t) => t.id.equals(item.id))).write(
        const SyncQueueCompanion(status: Value(0)),
      );
    }
  }

  Future<void> clearSynced() async {
    await (db.delete(db.syncQueue)..where((t) => t.status.equals(1))).go();
  }

  Future<Map<String, dynamic>> syncWithCloud() async {
    if (_isSyncing) return {'status': 'already_syncing'};
    if (!isConfigured) return {'status': 'not_configured'};

    _isSyncing = true;
    final results = <String, dynamic>{
      'pushed': 0,
      'failed': 0,
      'conflicts': 0,
      'pulled': 0,
    };

    try {
      if (_direction == SyncDirection.push ||
          _direction == SyncDirection.both) {
        final pending = await getPendingItems();
        for (final item in pending) {
          if (item.retryCount > 0) {
            final waitTime = pow(2, min(item.retryCount, 6)) * 5;
            if (item.createdAt
                .add(Duration(seconds: waitTime.toInt()))
                .isAfter(DateTime.now())) {
              continue;
            }
          }

          try {
            await _pushToServer(item);
            await markAsSynced(item.id);
            results['pushed'] = (results['pushed'] as int) + 1;
          } catch (e) {
            final isConflict = e.toString().contains('CONFLICT');
            if (isConflict) {
              await _resolveConflict(item, e.toString());
              results['conflicts'] = (results['conflicts'] as int) + 1;
            } else {
              await markAsFailed(item.id, e.toString());
              results['failed'] = (results['failed'] as int) + 1;
            }
          }
        }
      }

      if (_direction == SyncDirection.pull ||
          _direction == SyncDirection.both) {
        final pulledCount = await _pullFromServer();
        results['pulled'] = pulledCount;
      }
    } finally {
      _isSyncing = false;
    }

    return results;
  }

  Map<String, String> get _headers {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }

  Future<void> _pushToServer(SyncQueueData item) async {
    if (!isConfigured) return;
    final payload = jsonDecode(item.payload) as Map<String, dynamic>;
    final body = jsonEncode({
      'table': item.entityTable,
      'entityId': item.entityId,
      'operation': item.operation,
      'version': item.version,
      'deviceId': item.deviceId,
      'payload': payload,
    });
    final response = await _httpClient.post(
      Uri.parse('$_serverUrl/api/sync/push'),
      headers: _headers,
      body: body,
    );
    if (response.statusCode == 409) {
      throw Exception('CONFLICT: ${response.body}');
    }
    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }
  }

  Future<int> _pullFromServer() async {
    if (!isConfigured) return 0;
    final since = _lastSyncTime?.toIso8601String() ?? '';
    final uri = Uri.parse('$_serverUrl/api/sync/pull')
        .replace(queryParameters: {'since': since});
    final response = await _httpClient.get(uri, headers: _headers);
    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final changes = data['changes'] as List<dynamic>? ?? [];
    for (final change in changes) {
      final c = change as Map<String, dynamic>;
      await db.transaction(() async {
        final table = c['table'] as String;
        final entityId = c['entityId'] as String;
        final operation = c['operation'] as String;
        final payload = c['payload'] as Map<String, dynamic>;
        await addToQueue(
          table: table,
          entityId: entityId,
          operation: operation,
          payload: payload,
        );
      });
    }
    _lastSyncTime = DateTime.now();
    return changes.length;
  }

  Future<void> _resolveConflict(SyncQueueData item, String error) async {
    switch (_conflictStrategy) {
      case ConflictStrategy.serverWins:
        await _pullAndOverwrite(item);
        await markAsSynced(item.id);
        break;
      case ConflictStrategy.clientWins:
        await _pushToServer(item);
        await markAsSynced(item.id);
        break;
      case ConflictStrategy.lastWriteWins:
        final serverVersion = await _fetchServerVersion(item);
        if (serverVersion > item.version) {
          await _pullAndOverwrite(item);
        } else {
          await _pushToServer(item);
        }
        await markAsSynced(item.id);
        break;
      case ConflictStrategy.manual:
        await markAsFailed(item.id, 'CONFLICT: $error');
        break;
    }
  }

  Future<int> _fetchServerVersion(SyncQueueData item) async {
    if (!isConfigured) return 0;
    final uri = Uri.parse('$_serverUrl/api/sync/version')
        .replace(queryParameters: {
      'table': item.entityTable,
      'entityId': item.entityId,
    });
    final response = await _httpClient.get(uri, headers: _headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['version'] as int? ?? 0;
    }
    return 0;
  }

  Future<void> _pullAndOverwrite(SyncQueueData item) async {
    if (!isConfigured) return;
    final uri = Uri.parse('$_serverUrl/api/sync/entity')
        .replace(queryParameters: {
      'table': item.entityTable,
      'entityId': item.entityId,
    });
    final response = await _httpClient.get(uri, headers: _headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final payload = data['payload'] as Map<String, dynamic>?;
      if (payload != null) {
        await addToQueue(
          table: item.entityTable,
          entityId: item.entityId,
          operation: 'OVERWRITE',
          payload: payload,
        );
      }
    }
  }

  Future<List<Map<String, dynamic>>> getSyncHistory({int limit = 50}) async {
    final items = await (db.select(db.syncQueue)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(limit))
        .get();

    return items
        .map((item) => {
              'id': item.id,
              'table': item.entityTable,
              'entityId': item.entityId,
              'operation': item.operation,
              'status': item.status,
              'retryCount': item.retryCount,
              'error': item.lastError,
              'createdAt': item.createdAt.toIso8601String(),
            })
        .toList();
  }

  Future<Map<String, int>> getSyncStats() async {
    final pending = await getPendingCount();
    final failed = await getFailedCount();

    final syncedResult = await db
        .customSelect(
          "SELECT COUNT(*) as cnt FROM sync_queue WHERE status = 1",
        )
        .getSingle();

    return {
      'pending': pending,
      'failed': failed,
      'synced': syncedResult.data['cnt'] as int,
    };
  }

  void dispose() {
    _syncTimer?.cancel();
  }
}
