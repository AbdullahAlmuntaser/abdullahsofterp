import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/core/services/audit_service.dart';

AppDatabase _createDb() => AppDatabase(NativeDatabase.memory());

Future<void> _insertUser(AppDatabase db, {String id = 'user-1'}) async {
  await db.into(db.users).insert(UsersCompanion.insert(
    id: Value(id),
    username: 'testuser',
    password: 'pass',
    role: 'admin',
    fullName: 'Test User',
  ));
}

void main() {
  late AppDatabase db;
  late AuditService auditService;

  setUp(() {
    db = _createDb();
    auditService = AuditService(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('AuditService - log', () {
    test('logs a basic audit entry', () async {
      await auditService.log(
        action: 'CREATE',
        targetEntity: 'products',
        entityId: 'prod-1',
        details: 'تم إنشاء منتج جديد',
      );

      final logs = await (db.select(db.auditLogs)).get();
      expect(logs.length, equals(1));
      expect(logs.first.action, equals('CREATE'));
      expect(logs.first.targetEntity, equals('products'));
      expect(logs.first.entityId, equals('prod-1'));
      expect(logs.first.details, equals('تم إنشاء منتج جديد'));
    });

    test('logs with userId referencing existing user', () async {
      await _insertUser(db);

      await auditService.log(
        userId: 'user-1',
        action: 'UPDATE',
        targetEntity: 'sales',
        entityId: 'sale-1',
      );

      final logs = await (db.select(db.auditLogs)).get();
      expect(logs.length, equals(1));
      expect(logs.first.userId, equals('user-1'));
    });
  });

  group('AuditService - convenience methods', () {
    test('logCreate', () async {
      await _insertUser(db);
      await auditService.logCreate(
        'products',
        'prod-1',
        userId: 'user-1',
        details: 'منتج جديد',
      );

      final logs = await (db.select(db.auditLogs)).get();
      expect(logs.first.action, equals('CREATE'));
      expect(logs.first.targetEntity, equals('products'));
    });

    test('logUpdate', () async {
      await auditService.logUpdate(
        'products',
        'prod-1',
        details: 'تحديث السعر',
      );

      final logs = await (db.select(db.auditLogs)).get();
      expect(logs.first.action, equals('UPDATE'));
    });

    test('logDelete', () async {
      await auditService.logDelete('products', 'prod-1');

      final logs = await (db.select(db.auditLogs)).get();
      expect(logs.first.action, equals('DELETE'));
    });
  });

  group('AuditService - logAction with old/new values', () {
    test('logs with old and new values', () async {
      await _insertUser(db);
      await auditService.logAction(
        userId: 'user-1',
        action: 'UPDATE',
        logTableName: 'products',
        recordId: 'prod-1',
        oldValues: {'price': '100'},
        newValues: {'price': '120'},
      );

      final logs = await (db.select(db.auditLogs)).get();
      expect(logs.length, equals(1));
      expect(logs.first.action, equals('UPDATE'));
      expect(logs.first.oldValues, isNotNull);
      expect(logs.first.newValues, isNotNull);
    });
  });

  group('AuditService - queries', () {
    test('getAuditLogForTable returns matching logs', () async {
      await auditService.logCreate('products', 'prod-1');
      await auditService.logUpdate('products', 'prod-1');
      await auditService.logCreate('customers', 'cust-1');

      final productLogs = await auditService.getAuditLogForTable(
        'products',
        'prod-1',
      );

      expect(productLogs.length, equals(2));
      expect(
        productLogs.map((l) => l.action),
        containsAll(['CREATE', 'UPDATE']),
      );
    });

    test('getAuditLogForUser returns logs for specific user', () async {
      await _insertUser(db);
      await auditService.logCreate('products', 'prod-1', userId: 'user-1');
      await auditService.logCreate('products', 'prod-2', userId: 'user-1');
      await auditService.logCreate('products', 'prod-3');

      final userLogs = await auditService.getAuditLogForUser('user-1');
      expect(userLogs.length, equals(2));
    });
  });
}
