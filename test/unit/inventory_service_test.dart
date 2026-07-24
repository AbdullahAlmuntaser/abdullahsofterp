import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supermarket/core/services/inventory_service.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/core/services/audit_service.dart';
import 'package:supermarket/core/services/app_config_service.dart';
import 'package:supermarket/core/services/posting_engine.dart';

class MockAppDatabase extends Mock implements AppDatabase {}

class MockAuditService extends Mock implements AuditService {}

class MockAppConfigService extends Mock implements AppConfigService {}

class MockPostingEngine extends Mock implements PostingEngine {}

void main() {
  late MockAppDatabase mockDatabase;
  late MockAuditService mockAuditService;
  late MockAppConfigService mockConfigService;
  late MockPostingEngine mockPostingEngine;

  setUp(() {
    mockDatabase = MockAppDatabase();
    mockAuditService = MockAuditService();
    mockConfigService = MockAppConfigService();
    mockPostingEngine = MockPostingEngine();
  });

  group('InventoryService Tests', () {
    test('service can be created', () {
      final inventoryService = InventoryService.fromDb(
        mockDatabase,
        mockAuditService,
        mockConfigService,
        mockPostingEngine,
      );
      expect(inventoryService, isNotNull);
    });
  });
}
