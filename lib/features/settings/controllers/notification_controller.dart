import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/notifications/notification_service.dart';
import '../../../core/services/storage_service.dart';

class NotificationController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();
  NotificationService get _notificationService => Get.find<NotificationService>();

  final RxBool isNotificationsEnabled = true.obs;
  final RxInt selectedIntervalDays = 3.obs;
  final RxBool hasPermission = true.obs;
  final Rx<DateTime?> nextScheduledDate = Rx<DateTime?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
    _checkPermission();
  }

  void _loadSettings() {
    isNotificationsEnabled.value = _storage.isNotificationsEnabled();
    selectedIntervalDays.value = _storage.getNotificationIntervalDays();
    final nextTimestamp = _storage.getNextScheduledNotificationTimestamp();
    if (nextTimestamp != null) {
      nextScheduledDate.value =
          DateTime.fromMillisecondsSinceEpoch(nextTimestamp);
    }
  }

  Future<void> _checkPermission() async {
    try {
      final granted = await _notificationService.isPermissionGranted();
      hasPermission.value = granted;
    } catch (_) {
      hasPermission.value = true;
    }
  }

  Future<void> requestPermission() async {
    final granted = await _notificationService.requestPermission();
    hasPermission.value = granted;
    if (!granted) {
      _showSnackbar(
        AppStrings.permissionDeniedTitle,
        AppStrings.permissionDeniedMessage,
        backgroundColor: Colors.orange.shade800,
        duration: const Duration(seconds: 4),
      );
    }
  }

  Future<void> toggleNotifications(bool value) async {
    isNotificationsEnabled.value = value;
    await _storage.setNotificationsEnabled(value);

    if (value) {
      await requestPermission();
      final target = await _notificationService.scheduleInactivityReminder(
        customIntervalDays: selectedIntervalDays.value,
      );
      nextScheduledDate.value = target;
      _showSnackbar(
        'تم التفعيل',
        'تم تفعيل تذكيرات القرآن الكريم (${getIntervalLabel(selectedIntervalDays.value)})',
      );
    } else {
      await _notificationService.cancelReminder();
      nextScheduledDate.value = null;
      _showSnackbar(
        'تم الإيقاف',
        'تم إيقاف تذكيرات القرآن الكريم',
      );
    }
  }

  Future<void> changeInterval(int intervalDays) async {
    if (intervalDays <= 0) {
      // Turn off
      await toggleNotifications(false);
      return;
    }

    selectedIntervalDays.value = intervalDays;
    await _storage.setNotificationIntervalDays(intervalDays);

    if (!isNotificationsEnabled.value) {
      await toggleNotifications(true);
    } else {
      final target = await _notificationService.scheduleInactivityReminder(
        customIntervalDays: intervalDays,
      );
      nextScheduledDate.value = target;
      _showSnackbar(
        'تم تحديث الفترة',
        'سيصلك التذكير ${getIntervalLabel(intervalDays)} في حال الانقطاع',
      );
    }
  }

  Future<void> sendTestNotification() async {
    await requestPermission();
    await _notificationService.sendTestNotification();
    _showSnackbar(
      'إشعار تجريبي',
      AppStrings.testNotificationSent,
    );
  }

  void _showSnackbar(
    String title,
    String message, {
    Color backgroundColor = Colors.black87,
    Duration duration = const Duration(seconds: 2),
  }) {
    if (Get.context != null && Get.overlayContext != null) {
      try {
        Get.snackbar(
          title,
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: backgroundColor,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          duration: duration,
        );
      } catch (_) {}
    }
  }

  String getIntervalLabel(int days) {
    switch (days) {
      case 1:
        return AppStrings.intervalDaily;
      case 3:
        return AppStrings.intervalThreeDays;
      case 7:
        return AppStrings.intervalWeekly;
      case 30:
        return AppStrings.intervalMonthly;
      default:
        return 'كل $days أيام';
    }
  }
}
