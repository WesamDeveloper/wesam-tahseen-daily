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

  /// Quran Reading Bookmark keys
  static const String quranBookmarkSurah = 'quran_bookmark_surah';
  static const String quranBookmarkSurahName = 'quran_bookmark_surah_name';
  static const String quranBookmarkAyah = 'quran_bookmark_ayah';
  static const String quranBookmarkAyahText = 'quran_bookmark_ayah_text';
  static const String quranBookmarkTimestamp = 'quran_bookmark_timestamp';
}
