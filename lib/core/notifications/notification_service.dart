import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../services/storage_service.dart';
import 'notification_messages.dart';

class NotificationService extends GetxService with WidgetsBindingObserver {
  static const int quranReminderNotificationId = 1001;
  static const int testNotificationId = 9999;
  static const String channelId = 'quran_inactivity_reminder';
  static const String channelName = 'تذكير القرآن الكريم';
  static const String channelDescription =
      'إشعارات تذكيرية لطيفة لتلاوة القرآن الكريم عند الانقطاع عن التطبيق';

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  StorageService get _storage => Get.find<StorageService>();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<NotificationService> init() async {
    WidgetsBinding.instance.addObserver(this);

    // 1. Initialize timezone database and set local timezone matching system offset
    _initTimezone();

    // 2. Initialize local notifications plugin
    try {
      const androidSettings = AndroidInitializationSettings('@mipmap/launcher_icon');
      const darwinSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
      );

      await _notificationsPlugin.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) {
          // Handled if user taps notification
        },
      );

      // 3. Create Android notification channel
      final androidChannel = AndroidNotificationChannel(
        channelId,
        channelName,
        description: channelDescription,
        importance: Importance.high,
        enableVibration: true,
        playSound: true,
      );

      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        await androidPlugin.createNotificationChannel(androidChannel);
      }
    } catch (e) {
      debugPrint('NotificationService: native initialization skipped/unsupported: $e');
    }

    _isInitialized = true;

    // 4. Update last active timestamp and cancel any existing in-app reminder
    _onAppResumed();

    return this;
  }

  void _initTimezone() {
    tz.initializeTimeZones();
    final now = DateTime.now();
    try {
      final loc = tz.getLocation(now.timeZoneName);
      tz.setLocalLocation(loc);
    } catch (_) {
      // Find a matching location with identical timezone offset (Duration comparison)
      final locationName = tz.timeZoneDatabase.locations.keys.firstWhere(
        (key) {
          final l = tz.getLocation(key);
          return l.currentTimeZone.offset == now.timeZoneOffset;
        },
        orElse: () => 'UTC',
      );
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _onAppResumed();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _onAppPaused();
    }
  }

  void _onAppResumed() {
    // User is actively in the app:
    // Update last active timestamp
    _storage.setLastAppActiveTimestamp(DateTime.now().millisecondsSinceEpoch);

    // Cancel any pending reminder so no notification fires while inside app
    cancelReminder();
  }

  void _onAppPaused() {
    // User is leaving the app:
    // Schedule reminder if enabled
    if (_storage.isNotificationsEnabled()) {
      scheduleInactivityReminder();
    }
  }

  /// Request notification permission on Android (13+) and iOS
  Future<bool> requestPermission() async {
    try {
      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        final granted = await androidPlugin.requestNotificationsPermission();
        return granted ?? false;
      }

      final iosPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
      if (iosPlugin != null) {
        final granted = await iosPlugin.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return granted ?? false;
      }
    } catch (e) {
      debugPrint('Error requesting notification permission: $e');
    }
    return false;
  }

  /// Check if notification permission is currently granted
  Future<bool> isPermissionGranted() async {
    try {
      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        final enabled = await androidPlugin.areNotificationsEnabled();
        return enabled ?? true;
      }
      return true;
    } catch (e) {
      debugPrint('Error checking permission: $e');
      return true;
    }
  }

  /// Schedule the single Quran reminder after inactivity period
  Future<DateTime?> scheduleInactivityReminder({
    int? customIntervalDays,
    int? preferredHour,
  }) async {
    final enabled = _storage.isNotificationsEnabled();
    if (!enabled) {
      await cancelReminder();
      return null;
    }

    final intervalDays = customIntervalDays ?? _storage.getNotificationIntervalDays();
    if (intervalDays <= 0) {
      await cancelReminder();
      return null;
    }

    // Always cancel previous scheduled reminder first
    try {
      await _notificationsPlugin.cancel(id: quranReminderNotificationId);
    } catch (_) {}

    // Calculate target scheduled datetime
    final targetTime = _calculateScheduledDateTime(
      intervalDays: intervalDays,
      hour: preferredHour ?? _storage.getNotificationPreferredHour(),
    );

    final userName = _storage.getUserName();
    final lastMsgId = _storage.getLastNotificationMessageId();
    final message = NotificationMessages.getRandomMessage(lastId: lastMsgId);
    final bodyText = message.getBody(userName);

    // Save chosen message ID to prevent immediate repetition
    await _storage.setLastNotificationMessageId(message.id);
    await _storage.setNextScheduledNotificationTimestamp(
      targetTime.millisecondsSinceEpoch,
    );

    final notificationDetails = _getNotificationDetails();

    try {
      await _notificationsPlugin.zonedSchedule(
        id: quranReminderNotificationId,
        title: message.title,
        body: bodyText,
        scheduledDate: tz.TZDateTime.from(targetTime, tz.local),
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    } catch (e) {
      debugPrint('NotificationService: zonedSchedule failed: $e');
    }

    return targetTime;
  }

  /// Calculates comfortable daytime notification hour avoiding late night
  DateTime _calculateScheduledDateTime({
    required int intervalDays,
    int hour = 19,
  }) {
    final now = DateTime.now();

    // Ensure comfortable hour (between 08:00 and 21:00)
    int safeHour = hour;
    if (safeHour < 8 || safeHour > 21) {
      safeHour = 19; // Default to 7:00 PM
    }

    DateTime target = DateTime(
      now.year,
      now.month,
      now.day + intervalDays,
      safeHour,
      0,
    );

    // If target is in the past (e.g. interval is 0 or negative), move to next day
    if (target.isBefore(now)) {
      target = target.add(const Duration(days: 1));
    }

    return target;
  }

  /// Cancel all Quran reminder notifications
  Future<void> cancelReminder() async {
    try {
      await _notificationsPlugin.cancel(id: quranReminderNotificationId);
    } catch (_) {}
    await _storage.setNextScheduledNotificationTimestamp(null);
  }

  /// Sends an immediate test/preview notification with user's name
  Future<void> sendTestNotification() async {
    final userName = _storage.getUserName();
    final message = NotificationMessages.getRandomMessage();
    final body = message.getBody(userName);

    final details = _getNotificationDetails();

    try {
      await _notificationsPlugin.show(
        id: testNotificationId,
        title: message.title,
        body: body,
        notificationDetails: details,
      );
    } catch (e) {
      debugPrint('NotificationService: sendTestNotification failed: $e');
    }
  }

  NotificationDetails _getNotificationDetails() {
    const androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/launcher_icon',
      styleInformation: BigTextStyleInformation(''),
      enableVibration: true,
      playSound: true,
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    return const NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }
}
