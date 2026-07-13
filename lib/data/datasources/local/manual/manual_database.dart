import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;
import 'package:flutter/foundation.dart';

import 'package:supermarket/native_sql_override.dart';
import 'schemas.dart';

class ManualDatabase {
  static ManualDatabase? _instance;
  late sqlite.Database _db;
  bool _initialized = false;

  ManualDatabase._();

  static ManualDatabase get instance {
    _instance ??= ManualDatabase._();
    return _instance!;
  }

  sqlite.Database get db {
    if (!_initialized) {
      throw StateError('Database not initialized. Call initialize() first.');
    }
    return _db;
  }

  Future<void> initialize({String? encryptionKey}) async {
    if (_initialized) return;

    applyNativeSqlOverride();

    final dir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dir.path, 'supermarket_manual.db');

    _db = sqlite.sqlite3.open(dbPath);
    _db.execute('PRAGMA journal_mode = WAL;');
    _db.execute('PRAGMA foreign_keys = ON;');
    _db.execute('PRAGMA synchronous = NORMAL;');

    if (encryptionKey != null && encryptionKey.isNotEmpty) {
      _db.execute("PRAGMA key = '$encryptionKey';");
    }

    await _runMigrations();
    _initialized = true;
    debugPrint('ManualDatabase: initialized at $dbPath');
  }

  Future<void> _runMigrations() async {
    final version = _db.userVersion;
    if (version < 1) {
      for (final stmt in SchemaDefinitions.allTables) {
        try { _db.execute(stmt); } catch (e) { debugPrint('DB: $e'); }
      }
      for (final idx in SchemaDefinitions.allIndexes) {
        try { _db.execute(idx); } catch (e) { debugPrint('DB: idx $e'); }
      }
      _db.userVersion = 1;
    }
  }

  bool get isInitialized => _initialized;

  void close() {
    if (_initialized) {
      _db.dispose();
      _initialized = false;
    }
  }

  void execute(String sql, [List<Object?>? args]) {
    _db.execute(sql, args ?? []);
  }

  List<Map<String, dynamic>> query(String sql, [List<Object?>? args]) {
    final result = args != null && args.isNotEmpty
        ? _db.select(sql, args)
        : _db.select(sql);
    return result.map((row) => Map<String, dynamic>.from(row)).toList();
  }

  void transaction(void Function() fn) {
    _db.execute('BEGIN TRANSACTION;');
    try {
      fn();
      _db.execute('COMMIT;');
    } catch (e) {
      _db.execute('ROLLBACK;');
      rethrow;
    }
  }
}
