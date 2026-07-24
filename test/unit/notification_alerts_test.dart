import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supermarket/core/services/notification_service.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';

class MockAppDatabase extends Mock implements AppDatabase {}

void main() {
  late NotificationService notificationService;

  setUp(() {
    notificationService = NotificationService();
  });

  tearDown(() {
    notificationService.dispose();
  });

  group('NotificationService - Operational Alerts', () {
    test('notification categories are correct', () {
      notificationService.notify(
        title: 'Inventory',
        message: 'Low stock',
        category: 'inventory',
        sourceKey: 'test1',
      );
      notificationService.notify(
        title: 'Credit',
        message: 'Over limit',
        category: 'credit',
        sourceKey: 'test2',
      );
      notificationService.notify(
        title: 'Accounting',
        message: 'Imbalance',
        category: 'accounting',
        sourceKey: 'test3',
      );
      notificationService.notify(
        title: 'System',
        message: 'Info',
        category: 'system',
        sourceKey: 'test4',
      );

      final categories = notificationService.notifications
          .map((n) => n.category)
          .toSet();
      expect(categories,
          containsAll(['inventory', 'credit', 'accounting', 'system']));
    });

    test('notify with different severities', () {
      notificationService.notify(
        title: 'Info',
        message: 'Msg',
        category: 'test',
        severity: 'info',
        sourceKey: 'info1',
      );
      notificationService.notify(
        title: 'Warning',
        message: 'Msg',
        category: 'test',
        severity: 'warning',
        sourceKey: 'warn1',
      );
      notificationService.notify(
        title: 'Critical',
        message: 'Msg',
        category: 'test',
        severity: 'critical',
        sourceKey: 'crit1',
      );

      expect(
        notificationService.notifications
            .where((n) => n.severity == 'info')
            .length,
        equals(1),
      );
      expect(
        notificationService.notifications
            .where((n) => n.severity == 'warning')
            .length,
        equals(1),
      );
      expect(
        notificationService.notifications
            .where((n) => n.severity == 'critical')
            .length,
        equals(1),
      );
    });

    test('clearRead only removes read notifications', () {
      notificationService.notify(
        title: 'Read',
        message: '1',
        sourceKey: 'r1',
      );
      notificationService.notify(
        title: 'Unread',
        message: '2',
        sourceKey: 'u1',
      );

      final readId = notificationService.notifications
          .firstWhere((n) => n.title == 'Read')
          .id;
      notificationService.markAsRead(readId);

      notificationService.clearRead();

      expect(notificationService.notifications.length, equals(1));
      expect(notificationService.notifications.first.title, equals('Unread'));
    });

    test('duplicate sourceKey replaces old notification', () {
      notificationService.notify(
        title: 'Version 1',
        message: 'Old',
        category: 'inventory',
        sourceKey: 'product:123',
      );
      notificationService.notify(
        title: 'Version 2',
        message: 'New',
        category: 'inventory',
        sourceKey: 'product:123',
      );

      expect(notificationService.notifications.length, equals(1));
      expect(
          notificationService.notifications.first.title, equals('Version 2'));
    });

    test('unreadCount tracks correctly', () {
      expect(notificationService.unreadCount, equals(0));

      notificationService.notify(
        title: 'A',
        message: '1',
        sourceKey: 'a',
      );
      notificationService.notify(
        title: 'B',
        message: '2',
        sourceKey: 'b',
      );
      expect(notificationService.unreadCount, equals(2));

      final id =
          notificationService.notifications.first.id;
      notificationService.markAsRead(id);
      expect(notificationService.unreadCount, equals(1));
    });
  });
}
