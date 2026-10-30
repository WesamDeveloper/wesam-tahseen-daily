import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dene/core/notifications/notification_messages.dart';
import 'package:dene/core/services/storage_service.dart';
import 'package:dene/features/settings/controllers/settings_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late StorageService storageService;

  setUp(() async {
    Get.reset();
    SharedPreferences.setMockInitialValues({});
    storageService = StorageService();
    await storageService.init();
    Get.put<StorageService>(storageService, permanent: true);
  });

  tearDown(() {
    Get.reset();
  });

  group('1. Default Settings & First Install Scenarios', () {
    test('Default reminder is enabled by default', () {
      expect(storageService.isNotificationsEnabled(), true);
    });

    test('Default interval is 3 days', () {
      expect(storageService.getNotificationIntervalDays(), 3);
    });

    test('Default user name is null when not set', () {
      expect(storageService.getUserName(), isNull);
    });
  });

  group('2. User Name Persistence & Profile Scenarios', () {
    test('Entering and saving user name stores it locally', () async {
      final controller = SettingsController();
      controller.onInit();

      expect(controller.userName.value, '');
      controller.saveUserName('وسام');

      expect(controller.userName.value, 'وسام');
      expect(storageService.getUserName(), 'وسام');
    });

    test('Trimming whitespace when saving name', () async {
      final controller = SettingsController();
      controller.onInit();

      controller.saveUserName('   أحمد   ');
      expect(controller.userName.value, 'أحمد');
      expect(storageService.getUserName(), 'أحمد');
    });

    test('Deleting or clearing user name restores general state', () async {
      await storageService.setUserName('وسام');
      final controller = SettingsController();
      controller.onInit();

      expect(controller.userName.value, 'وسام');
      controller.clearUserName();

      expect(controller.userName.value, '');
      expect(storageService.getUserName(), isNull);
    });
  });

  group('3. Notification Messages & Personalization', () {
    test('Message includes user name when available', () {
      final msg = NotificationMessages.messages.firstWhere(
        (m) => m.id == 5, // Friendly message
      );
      final bodyWithName = msg.getBody('وسام');
      expect(bodyWithName.contains('وسام'), true);
    });

    test('Message renders clean general text when name is absent', () {
      final msg = NotificationMessages.messages.firstWhere(
        (m) => m.id == 5,
      );
      final bodyWithoutName = msg.getBody(null);
      expect(bodyWithoutName.contains('يا null'), false);
      expect(bodyWithoutName.contains('وسام'), false);
      expect(bodyWithoutName, 'لقد اشتقنا لقراءتك، ألا نفتح المصحف اليوم؟');
    });

    test('Message renders clean general text when name is whitespace', () {
      final msg = NotificationMessages.messages.firstWhere(
        (m) => m.id == 11,
      );
      final bodyWithSpaces = msg.getBody('   ');
      expect(bodyWithSpaces, 'دعنا نقرأ القرآن اليوم ❤️');
    });

    test('Random selection avoids repeating the last message ID directly', () {
      const lastId = 7;
      final rng = Random(42);

      for (int i = 0; i < 50; i++) {
        final chosen = NotificationMessages.getRandomMessage(
          lastId: lastId,
          random: rng,
        );
        expect(chosen.id, isNot(lastId));
      }
    });

    test('Message diversity covers required motivational, friendly and reminder tones', () {
      expect(NotificationMessages.messages.length, greaterThanOrEqualTo(15));

      final allBodies = NotificationMessages.messages
          .map((m) => m.getBody('وسام'))
          .toList();

      // Check key phrases from requirements
      expect(allBodies.any((b) => b.contains('لا تجعل يومك يخلو من القرآن')), true);
      expect(allBodies.any((b) => b.contains('افتح مصحفك')), true);
      expect(allBodies.any((b) => b.contains('لقد اشتقنا لقراءتك')), true);
      expect(allBodies.any((b) => b.contains('لقد هجرتني')), true);
      expect(allBodies.any((b) => b.contains('وردك من القرآن')), true);
    });
  });

  group('4. Interval Updates & Storage Cancellation Logic', () {
    test('Changing interval updates storage correctly', () async {
      await storageService.setNotificationIntervalDays(1);
      expect(storageService.getNotificationIntervalDays(), 1);

      await storageService.setNotificationIntervalDays(7);
      expect(storageService.getNotificationIntervalDays(), 7);

      await storageService.setNotificationIntervalDays(30);
      expect(storageService.getNotificationIntervalDays(), 30);
    });

    test('Disabling reminder sets status to false and persists across restarts', () async {
      await storageService.setNotificationsEnabled(false);
      expect(storageService.isNotificationsEnabled(), false);

      // Simulate app restart by re-initializing storage service
      final newStorage = StorageService();
      await newStorage.init();
      expect(newStorage.isNotificationsEnabled(), false);
    });

    test('Re-enabling reminder sets status to true and persists across restarts', () async {
      await storageService.setNotificationsEnabled(false);
      expect(storageService.isNotificationsEnabled(), false);

      await storageService.setNotificationsEnabled(true);
      expect(storageService.isNotificationsEnabled(), true);

      final newStorage = StorageService();
      await newStorage.init();
      expect(newStorage.isNotificationsEnabled(), true);
    });
  });

  group('5. Inactivity & Timestamp Tracking Logic', () {
    test('Last active timestamp is updated on user activity', () async {
      final now = DateTime.now().millisecondsSinceEpoch;
      await storageService.setLastAppActiveTimestamp(now);

      expect(storageService.getLastAppActiveTimestamp(), now);
    });

    test('Next scheduled notification timestamp is saved and cleared', () async {
      final scheduled = DateTime.now().add(const Duration(days: 3)).millisecondsSinceEpoch;
      await storageService.setNextScheduledNotificationTimestamp(scheduled);
      expect(storageService.getNextScheduledNotificationTimestamp(), scheduled);

      await storageService.setNextScheduledNotificationTimestamp(null);
      expect(storageService.getNextScheduledNotificationTimestamp(), isNull);
    });
  });
}
