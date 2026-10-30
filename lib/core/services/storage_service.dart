import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/quran/models/quran_bookmark.dart';
import '../constants/storage_keys.dart';

class StorageService extends GetxService {
  late final SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  int getTotalReadCount() {
    return _prefs.getInt(StorageKeys.totalRead) ?? 0;
  }

  Future<bool> setTotalReadCount(int value) async {
    return await _prefs.setInt(StorageKeys.totalRead, value);
  }

  Future<int> addReadCount(int added) async {
    final currentTotal = getTotalReadCount();
    final newTotal = currentTotal + added;
    await setTotalReadCount(newTotal);
    return newTotal;
  }

  // --- User Profile ---
  String? getUserName() {
    final name = _prefs.getString(StorageKeys.userName);
    if (name != null && name.trim().isNotEmpty) {
      return name.trim();
    }
    return null;
  }

  Future<bool> setUserName(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return await removeUserName();
    }
    return await _prefs.setString(StorageKeys.userName, trimmed);
  }

  Future<bool> removeUserName() async {
    return await _prefs.remove(StorageKeys.userName);
  }

  // --- Notifications Preferences ---
  bool isNotificationsEnabled({bool defaultValue = true}) {
    return _prefs.getBool(StorageKeys.notificationsEnabled) ?? defaultValue;
  }

  Future<bool> setNotificationsEnabled(bool value) async {
    return await _prefs.setBool(StorageKeys.notificationsEnabled, value);
  }

  int getNotificationIntervalDays({int defaultValue = 3}) {
    return _prefs.getInt(StorageKeys.notificationIntervalDays) ?? defaultValue;
  }

  Future<bool> setNotificationIntervalDays(int days) async {
    return await _prefs.setInt(StorageKeys.notificationIntervalDays, days);
  }

  int getNotificationPreferredHour({int defaultValue = 19}) {
    return _prefs.getInt(StorageKeys.notificationPreferredHour) ?? defaultValue;
  }

  Future<bool> setNotificationPreferredHour(int hour) async {
    return await _prefs.setInt(StorageKeys.notificationPreferredHour, hour);
  }

  int? getLastAppActiveTimestamp() {
    return _prefs.getInt(StorageKeys.lastAppActiveTimestamp);
  }

  Future<bool> setLastAppActiveTimestamp(int timestamp) async {
    return await _prefs.setInt(StorageKeys.lastAppActiveTimestamp, timestamp);
  }

  int? getLastNotificationMessageId() {
    return _prefs.getInt(StorageKeys.lastNotificationMessageId);
  }

  Future<bool> setLastNotificationMessageId(int id) async {
    return await _prefs.setInt(StorageKeys.lastNotificationMessageId, id);
  }

  int? getNextScheduledNotificationTimestamp() {
    return _prefs.getInt(StorageKeys.nextScheduledNotificationTimestamp);
  }

  Future<bool> setNextScheduledNotificationTimestamp(int? timestamp) async {
    if (timestamp == null) {
      return await _prefs.remove(StorageKeys.nextScheduledNotificationTimestamp);
    }
    return await _prefs.setInt(
      StorageKeys.nextScheduledNotificationTimestamp,
      timestamp,
    );
  }

  // --- Quran Reading Bookmark ---
  QuranBookmark? getQuranBookmark() {
    final surah = _prefs.getInt(StorageKeys.quranBookmarkSurah);
    final surahName = _prefs.getString(StorageKeys.quranBookmarkSurahName);
    final ayah = _prefs.getInt(StorageKeys.quranBookmarkAyah);
    final ayahText = _prefs.getString(StorageKeys.quranBookmarkAyahText);
    final timeStr = _prefs.getString(StorageKeys.quranBookmarkTimestamp);

    if (surah == null || surahName == null || ayah == null) {
      return null;
    }

    return QuranBookmark(
      surahNumber: surah,
      surahName: surahName,
      ayahNumber: ayah,
      ayahText: ayahText,
      timestamp: timeStr != null
          ? (DateTime.tryParse(timeStr) ?? DateTime.now())
          : DateTime.now(),
    );
  }

  Future<bool> saveQuranBookmark(QuranBookmark bookmark) async {
    await _prefs.setInt(StorageKeys.quranBookmarkSurah, bookmark.surahNumber);
    await _prefs.setString(
      StorageKeys.quranBookmarkSurahName,
      bookmark.surahName,
    );
    await _prefs.setInt(StorageKeys.quranBookmarkAyah, bookmark.ayahNumber);
    if (bookmark.ayahText != null) {
      await _prefs.setString(
        StorageKeys.quranBookmarkAyahText,
        bookmark.ayahText!,
      );
    } else {
      await _prefs.remove(StorageKeys.quranBookmarkAyahText);
    }
    await _prefs.setString(
      StorageKeys.quranBookmarkTimestamp,
      bookmark.timestamp.toIso8601String(),
    );
    return true;
  }

  Future<bool> removeQuranBookmark() async {
    await _prefs.remove(StorageKeys.quranBookmarkSurah);
    await _prefs.remove(StorageKeys.quranBookmarkSurahName);
    await _prefs.remove(StorageKeys.quranBookmarkAyah);
    await _prefs.remove(StorageKeys.quranBookmarkAyahText);
    await _prefs.remove(StorageKeys.quranBookmarkTimestamp);
    return true;
  }

  bool hasQuranBookmark() {
    return _prefs.getInt(StorageKeys.quranBookmarkSurah) != null &&
        _prefs.getInt(StorageKeys.quranBookmarkAyah) != null;
  }

  SharedPreferences get rawPrefs => _prefs;
}
