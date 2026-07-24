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

  group('NotificationService - Core', () {
    test('starts with empty notifications', () {
      expect(notificationService.notifications, isEmpty);
      expect(notificationService.unreadCount, equals(0));
    });

    test('notify adds notification', () {
      notificationService.notify(
        title: 'Test',
        message: 'Message',
        category: 'test',
      );

      expect(notificationService.notifications.length, equals(1));
      expect(notificationService.notifications.first.title, equals('Test'));
      expect(notificationService.notifications.first.severity, equals('info'));
    });

    test('notify deduplicates by sourceKey', () {
      notificationService.notify(
        title: 'First',
        message: 'Msg1',
        category: 'test',
        sourceKey: 'item:1',
      );
      notificationService.notify(
        title: 'Second',
        message: 'Msg2',
        category: 'test',
        sourceKey: 'item:1',
      );

      expect(notificationService.notifications.length, equals(1));
      expect(notificationService.notifications.first.title, equals('Second'));
    });

    test('notify without sourceKey does not deduplicate', () {
      notificationService.notify(title: 'A', message: '1', category: 'test');
      notificationService.notify(title: 'B', message: '2', category: 'test');

      expect(notificationService.notifications.length, equals(2));
    });

    test('markAsRead works', () {
      notificationService.notify(
        title: 'Test',
        message: 'Msg',
        category: 'test',
      );
      final id = notificationService.notifications.first.id;

      expect(notificationService.unreadCount, equals(1));

      notificationService.markAsRead(id);
      expect(notificationService.unreadCount, equals(0));
      expect(notificationService.notifications.first.isRead, isTrue);
    });

    test('markAllAsRead works', () {
      notificationService.notify(title: 'A', message: '1');
      notificationService.notify(title: 'B', message: '2');

      expect(notificationService.unreadCount, equals(2));

      notificationService.markAllAsRead();
      expect(notificationService.unreadCount, equals(0));
    });

    test('clearRead removes read notifications', () {
      notificationService.notify(title: 'A', message: '1');
      notificationService.notify(title: 'B', message: '2');
      final id = notificationService.notifications.first.id;
      notificationService.markAsRead(id);

      notificationService.clearRead();
      expect(notificationService.notifications.length, equals(1));
      expect(notificationService.notifications.first.title, equals('B'));
    });

    test('showNotification creates system notification', () async {
      await notificationService.showNotification(1, 'Title', 'Body');

      expect(notificationService.notifications.length, equals(1));
      expect(notificationService.notifications.first.category, equals('system'));
      expect(
          notificationService.notifications.first.severity, equals('warning'));
    });

    test('notifications stream emits updates', () async {
      final stream = notificationService.notificationsStream;

      final future = stream.first;
      notificationService.notify(title: 'Test', message: 'Msg');

      final notifications = await future;
      expect(notifications.length, equals(1));
    });
  });
}
