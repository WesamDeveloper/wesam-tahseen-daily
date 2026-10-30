class StorageKeys {
  StorageKeys._();

  /// Key used by the original app to persist total read azkar count.
  /// Must be kept identical to preserve existing user data.
  static const String totalRead = 'total_read';

  /// User profile settings
  static const String userName = 'user_name';

  /// Notification preferences
  static const String notificationsEnabled = 'notifications_enabled';
  static const String notificationIntervalDays = 'notification_interval_days';
  static const String notificationPreferredHour = 'notification_preferred_hour';
  static const String lastAppActiveTimestamp = 'last_app_active_timestamp';
  static const String lastNotificationMessageId = 'last_notification_message_id';
  static const String nextScheduledNotificationTimestamp = 'next_scheduled_notification_timestamp';
}
